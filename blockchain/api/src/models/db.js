/**
 * models/db.js
 *
 * Thin wrapper around the pg Pool.
 * All SQL queries go through db.query() so we have one connection pool.
 */

const { Pool } = require("pg");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

pool.on("error", (err) => {
  console.error("Unexpected DB error:", err);
});

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool,
};
