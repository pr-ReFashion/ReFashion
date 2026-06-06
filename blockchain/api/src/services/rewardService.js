/**
 * services/rewardService.js
 *
 * Core reward business logic: issue and deduct.
 *
 * Idempotency:
 * - Every mint/burn call includes a rewardEventId.
 * - Before hitting the blockchain, we check if this eventId already exists in DB.
 * - If it does, we return the existing tx hash (safe to call multiple times).
 * - This protects against double-minting caused by retries or network errors.
 *
 * Error handling:
 * - We write a PENDING record before the blockchain call.
 * - On success, update to CONFIRMED with tx hash.
 * - On failure, update to FAILED. The caller can retry.
 */

const blockchain = require("../blockchain/client");
const db = require("../models/db");
const { withRetry } = require("../utils/retry");

async function issueReward({ userId, walletAddress, amount, rewardEventId }) {
  // 1. Idempotency check
  const existing = await db.query(
    "SELECT * FROM reward_events WHERE reward_event_id = $1",
    [rewardEventId]
  );
  if (existing.rows.length > 0) {
    const row = existing.rows[0];
    return { duplicate: true, txHash: row.tx_hash, status: row.status };
  }

  // 2. Write PENDING record
  await db.query(
    `INSERT INTO reward_events (reward_event_id, user_id, amount, type, status, created_at)
     VALUES ($1, $2, $3, 'MINT', 'PENDING', NOW())`,
    [rewardEventId, userId, amount]
  );

  try {
    // 3. Mint on-chain with retry
    const { txHash, blockNumber } = await withRetry(
      () => blockchain.mintTokens(walletAddress, amount, rewardEventId),
      { label: `mint:${rewardEventId}`, maxAttempts: 3 }
    );

    // 4. Confirm in DB
    await db.query(
      `UPDATE reward_events
       SET tx_hash = $1, status = 'CONFIRMED', block_number = $2
       WHERE reward_event_id = $3`,
      [txHash, blockNumber, rewardEventId]
    );

    return { duplicate: false, txHash, blockNumber, status: "CONFIRMED" };
  } catch (err) {
    // 5. Mark as failed so it can be retried or investigated
    await db.query(
      `UPDATE reward_events SET status = 'FAILED', error = $1 WHERE reward_event_id = $2`,
      [err.message, rewardEventId]
    );
    throw err;
  }
}

async function deductReward({ userId, walletAddress, amount, rewardEventId }) {
  const existing = await db.query(
    "SELECT * FROM reward_events WHERE reward_event_id = $1",
    [rewardEventId]
  );
  if (existing.rows.length > 0) {
    const row = existing.rows[0];
    return { duplicate: true, txHash: row.tx_hash, status: row.status };
  }

  await db.query(
    `INSERT INTO reward_events (reward_event_id, user_id, amount, type, status, created_at)
     VALUES ($1, $2, $3, 'BURN', 'PENDING', NOW())`,
    [rewardEventId, userId, amount]
  );

  try {
    const { txHash, blockNumber } = await withRetry(
      () => blockchain.burnTokens(walletAddress, amount, rewardEventId),
      { label: `burn:${rewardEventId}`, maxAttempts: 3 }
    );

    await db.query(
      `UPDATE reward_events
       SET tx_hash = $1, status = 'CONFIRMED', block_number = $2
       WHERE reward_event_id = $3`,
      [txHash, blockNumber, rewardEventId]
    );

    return { duplicate: false, txHash, blockNumber, status: "CONFIRMED" };
  } catch (err) {
    await db.query(
      `UPDATE reward_events SET status = 'FAILED', error = $1 WHERE reward_event_id = $2`,
      [err.message, rewardEventId]
    );
    throw err;
  }
}

module.exports = { issueReward, deductReward };
