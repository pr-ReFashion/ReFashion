/**
 * scripts/retryFailed.js
 *
 * Finds all FAILED reward events and attempts to replay them.
 * Run manually when you know the blockchain was temporarily unavailable:
 *
 *   node src/scripts/retryFailed.js
 *   node src/scripts/retryFailed.js --dry-run   (just lists failures, no action)
 *
 * Safe to run multiple times — idempotency check in rewardService prevents
 * double-minting even if a transaction actually succeeded before being marked FAILED.
 *
 * Note on PENDING events:
 * PENDING means the server may have crashed mid-transaction.
 * These require manual investigation to check the chain before retrying.
 * This script logs them but does NOT auto-retry them.
 */

require("dotenv").config();
const db = require("../models/db");
const blockchain = require("../blockchain/client");
const { withRetry } = require("../utils/retry");

const DRY_RUN = process.argv.includes("--dry-run");

async function main() {
  console.log(`=== Retry Failed Transactions ${DRY_RUN ? "(DRY RUN)" : ""} ===\n`);

  // ── Report PENDING events (do not auto-retry) ─────────────────────────────
  const pending = await db.query(
    "SELECT * FROM reward_events WHERE status = 'PENDING' ORDER BY created_at ASC"
  );
  if (pending.rows.length > 0) {
    console.warn(`⚠️  ${pending.rows.length} PENDING event(s) require manual review:`);
    pending.rows.forEach((row) => {
      console.warn(`   - ${row.reward_event_id} | ${row.type} ${row.amount} | user: ${row.user_id} | created: ${row.created_at}`);
    });
    console.warn("   Check the chain to see if these transactions landed before retrying.\n");
  }

  // ── Retry FAILED events ───────────────────────────────────────────────────
  const failed = await db.query(
    "SELECT * FROM reward_events WHERE status = 'FAILED' ORDER BY created_at ASC"
  );

  if (failed.rows.length === 0) {
    console.log("✅ No FAILED events found.");
    process.exit(0);
  }

  console.log(`Found ${failed.rows.length} FAILED event(s) to retry:\n`);

  for (const row of failed.rows) {
    console.log(`→ ${row.reward_event_id} | ${row.type} ${row.amount} RFT | user: ${row.user_id}`);
    console.log(`  Previous error: ${row.error}`);

    if (DRY_RUN) {
      console.log("  [DRY RUN] Skipping.\n");
      continue;
    }

    // Get the user's wallet address
    const userResult = await db.query(
      "SELECT wallet_address FROM users WHERE id = $1",
      [row.user_id]
    );
    if (userResult.rows.length === 0) {
      console.error(`  ❌ User not found: ${row.user_id}. Skipping.\n`);
      continue;
    }
    const walletAddress = userResult.rows[0].wallet_address;

    try {
      // Reset to PENDING before retrying
      await db.query(
        "UPDATE reward_events SET status = 'PENDING', error = NULL WHERE reward_event_id = $1",
        [row.reward_event_id]
      );

      const callFn =
        row.type === "MINT"
          ? () => blockchain.mintTokens(walletAddress, row.amount, row.reward_event_id)
          : () => blockchain.burnTokens(walletAddress, row.amount, row.reward_event_id);

      const { txHash, blockNumber } = await withRetry(callFn, {
        label: `retry:${row.reward_event_id}`,
        maxAttempts: 3,
      });

      await db.query(
        `UPDATE reward_events
         SET tx_hash = $1, status = 'CONFIRMED', block_number = $2, error = NULL
         WHERE reward_event_id = $3`,
        [txHash, blockNumber, row.reward_event_id]
      );

      console.log(`  ✅ Confirmed. tx: ${txHash}\n`);
    } catch (err) {
      await db.query(
        "UPDATE reward_events SET status = 'FAILED', error = $1 WHERE reward_event_id = $2",
        [err.message, row.reward_event_id]
      );
      console.error(`  ❌ Still failing: ${err.message}\n`);
    }
  }

  console.log("=== Done ===");
  process.exit(0);
}

main().catch((err) => {
  console.error("Unexpected error:", err);
  process.exit(1);
});
