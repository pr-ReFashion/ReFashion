import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { Pool, PoolClient } from "pg"

const globalForPg = globalThis as unknown as { __refashionPgPool?: Pool }

const pool =
  globalForPg.__refashionPgPool ??
  new Pool({
    connectionString: process.env.DATABASE_URL,
  })

if (!globalForPg.__refashionPgPool) {
  globalForPg.__refashionPgPool = pool
}

type ChildFk = {
  child_schema: string
  child_table: string
  child_column: string
}

const quoteIdent = (s: string) => `"${s.replace(/"/g, "\"\"")}"`

async function tableHasId(client: PoolClient, schema: string, table: string) {
  const q = await client.query(
    `
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = $1
      AND table_name = $2
      AND column_name = 'id'
    LIMIT 1
    `,
    [schema, table]
  )

  return q.rowCount > 0
}

async function getReferencingTables(
  client: PoolClient,
  schema: string,
  table: string
): Promise<ChildFk[]> {
  const q = await client.query(
    `
    SELECT DISTINCT
      ns.nspname AS child_schema,
      cls.relname AS child_table,
      att2.attname AS child_column
    FROM pg_constraint con
    JOIN pg_class cls
      ON cls.oid = con.conrelid
    JOIN pg_namespace ns
      ON ns.oid = cls.relnamespace
    JOIN pg_class parent
      ON parent.oid = con.confrelid
    JOIN pg_namespace pns
      ON pns.oid = parent.relnamespace
    JOIN unnest(con.conkey) WITH ORDINALITY AS ck(attnum, ord)
      ON true
    JOIN unnest(con.confkey) WITH ORDINALITY AS fk(attnum, ord)
      ON ck.ord = fk.ord
    JOIN pg_attribute att2
      ON att2.attrelid = con.conrelid
     AND att2.attnum = ck.attnum
    JOIN pg_attribute patt
      ON patt.attrelid = con.confrelid
     AND patt.attnum = fk.attnum
    WHERE con.contype = 'f'
      AND pns.nspname = $1
      AND parent.relname = $2
      AND patt.attname = 'id'
      AND cardinality(con.conkey) = 1
      AND cardinality(con.confkey) = 1
    ORDER BY child_schema, child_table, child_column
    `,
    [schema, table]
  )

  return q.rows as ChildFk[]
}

async function findMatchingSeller(
  client: PoolClient,
  customer: {
    email?: string | null
    first_name?: string | null
    last_name?: string | null
  }
): Promise<{ sellerId: string | null; strategy: "email" | "name" | null }> {
  const email = (customer.email || "").trim()
  const fullName = `${customer.first_name || ""} ${customer.last_name || ""}`.trim()

  // 1) Prefer exact email match
  if (email) {
    const byEmail = await client.query(
      `
      SELECT id
      FROM public.seller
      WHERE deleted_at IS NULL
        AND lower(trim(email)) = lower(trim($1))
      ORDER BY id ASC
      LIMIT 2
      `,
      [email]
    )

    if (byEmail.rowCount === 1) {
      return { sellerId: byEmail.rows[0].id, strategy: "email" }
    }
  }

  // 2) Fallback exact full-name match, only if unique
  if (fullName) {
    const byName = await client.query(
      `
      SELECT id
      FROM public.seller
      WHERE deleted_at IS NULL
        AND lower(trim(name)) = lower(trim($1))
      ORDER BY id ASC
      LIMIT 2
      `,
      [fullName]
    )

    if (byName.rowCount === 1) {
      return { sellerId: byName.rows[0].id, strategy: "name" }
    }
  }

  return { sellerId: null, strategy: null }
}


async function purgeRowRecursive(
  client: PoolClient,
  schema: string,
  table: string,
  id: string,
  visited: Set<string>,
  deletedCounts: Record<string, number>
) {
  const visitKey = `${schema}.${table}:${id}`
  if (visited.has(visitKey)) {
    return
  }
  visited.add(visitKey)

  const children = await getReferencingTables(client, schema, table)

  for (const child of children) {
    const childTableKey = `${child.child_schema}.${child.child_table}`
    const childHasId = await tableHasId(client, child.child_schema, child.child_table)

    if (childHasId) {
      const selectSql = `
        SELECT id
        FROM ${quoteIdent(child.child_schema)}.${quoteIdent(child.child_table)}
        WHERE ${quoteIdent(child.child_column)} = $1
      `
      const childRows = await client.query(selectSql, [id])

      for (const row of childRows.rows) {
        await purgeRowRecursive(
          client,
          child.child_schema,
          child.child_table,
          row.id,
          visited,
          deletedCounts
        )
      }
    } else {
      const deleteSql = `
        DELETE FROM ${quoteIdent(child.child_schema)}.${quoteIdent(child.child_table)}
        WHERE ${quoteIdent(child.child_column)} = $1
      `
      const deleted = await client.query(deleteSql, [id])
      deletedCounts[childTableKey] = (deletedCounts[childTableKey] || 0) + deleted.rowCount
    }
  }

  const deleteSelfSql = `
    DELETE FROM ${quoteIdent(schema)}.${quoteIdent(table)}
    WHERE id = $1
  `
  const deletedSelf = await client.query(deleteSelfSql, [id])

  const selfKey = `${schema}.${table}`
  deletedCounts[selfKey] = (deletedCounts[selfKey] || 0) + deletedSelf.rowCount
}

export const DELETE = async (req: MedusaRequest, res: MedusaResponse) => {
  const customerId = req.params.id

  if (!customerId) {
    return res.status(400).json({ message: "Missing customer id" })
  }

  const client = await pool.connect()

  try {
    await client.query("BEGIN")

    const customerQ = await client.query(
      `
      SELECT id, email, first_name, last_name
      FROM public.customer
      WHERE id = $1
      LIMIT 1
      `,
      [customerId]
    )

    if (customerQ.rowCount === 0) {
      await client.query("ROLLBACK")
      return res.status(404).json({ message: "Customer not found" })
    }

    const customerRow = customerQ.rows[0]

    const { sellerId, strategy } = await findMatchingSeller(client, customerRow)

    const visited = new Set<string>()
    const deletedCounts: Record<string, number> = {}

    // 1) delete customer tree
    await purgeRowRecursive(
      client,
      "public",
      "customer",
      customerId,
      visited,
      deletedCounts
    )

    // 2) delete matching seller tree, if found
    if (sellerId) {
      await purgeRowRecursive(
        client,
        "public",
        "seller",
        sellerId,
        visited,
        deletedCounts
      )
    }

    await client.query("COMMIT")

    return res.status(200).json({
      ok: true,
      entity: "customer",
      deleted_root_id: customerId,
      deleted_matching_seller_id: sellerId,
      seller_match_strategy: strategy,
      deleted_counts: deletedCounts,
    })
  } catch (e: any) {
    await client.query("ROLLBACK")

    return res.status(500).json({
      message: e?.message ?? "Customer force delete failed",
      code: e?.code ?? null,
      detail: e?.detail ?? null,
    })
  } finally {
    client.release()
  }
}