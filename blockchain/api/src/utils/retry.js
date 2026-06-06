/**
 * utils/retry.js
 *
 * Exponential backoff retry wrapper for blockchain transactions.
 *
 * Why we need this:
 * - RPC nodes occasionally drop connections or return transient errors.
 * - Nonce collisions can happen under load.
 * - Network congestion can cause timeout errors.
 *
 * What we retry:
 * - Transient RPC errors (connection refused, timeout, rate limit)
 *
 * What we do NOT retry:
 * - Insufficient balance (BURN with not enough tokens — logical error, not transient)
 * - Contract reverts with known error messages (e.g. "RFT: amount must be > 0")
 * - These should surface immediately so the caller knows to fix their request.
 */

// Errors that indicate a transient infrastructure problem — safe to retry
const RETRYABLE_MESSAGES = [
  "timeout",
  "network error",
  "connection refused",
  "rate limit",
  "too many requests",
  "server error",
  "internal error",
  "nonce too low",
  "replacement fee too low",
  "ECONNRESET",
  "ETIMEDOUT",
  "ENOTFOUND",
];

// Contract-level errors — do NOT retry, surface immediately
const NON_RETRYABLE_MESSAGES = [
  "insufficient balance",
  "amount must be > 0",
  "mint to zero address",
  "burn from zero address",
  "transfers disabled",
  "AccessControl",
  "EnforcedPause",
];

function isRetryable(error) {
  const msg = (error.message || "").toLowerCase();

  // If it matches a known non-retryable pattern, don't retry
  if (NON_RETRYABLE_MESSAGES.some((p) => msg.includes(p.toLowerCase()))) {
    return false;
  }

  // If it matches a known transient pattern, retry
  if (RETRYABLE_MESSAGES.some((p) => msg.includes(p.toLowerCase()))) {
    return true;
  }

  // For unknown errors, retry cautiously (better than silently failing)
  return true;
}

/**
 * @param {Function} fn        Async function to retry
 * @param {Object}   options
 * @param {number}   options.maxAttempts   Default: 3
 * @param {number}   options.baseDelayMs   Default: 500ms (doubles each attempt)
 * @param {string}   options.label         Used in log output
 */
async function withRetry(fn, { maxAttempts = 3, baseDelayMs = 500, label = "operation" } = {}) {
  let lastError;

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (err) {
      lastError = err;

      if (!isRetryable(err)) {
        console.error(`[retry] ${label} — non-retryable error on attempt ${attempt}:`, err.message);
        throw err;
      }

      if (attempt === maxAttempts) {
        console.error(`[retry] ${label} — failed after ${maxAttempts} attempts:`, err.message);
        break;
      }

      const delay = baseDelayMs * Math.pow(2, attempt - 1); // 500ms, 1000ms, 2000ms...
      console.warn(
        `[retry] ${label} — attempt ${attempt} failed: ${err.message}. Retrying in ${delay}ms...`
      );
      await sleep(delay);
    }
  }

  throw lastError;
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports = { withRetry, isRetryable };
