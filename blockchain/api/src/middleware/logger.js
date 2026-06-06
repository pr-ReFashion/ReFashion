/**
 * middleware/logger.js
 *
 * Logs every request with method, path, status, and duration.
 * Redacts the Authorization header so API keys never appear in logs.
 *
 * Format: [2024-01-15T10:23:45.123Z] POST /rewards/issue 201 145ms
 */

function requestLogger(req, res, next) {
  const start = Date.now();

  res.on("finish", () => {
    const duration = Date.now() - start;
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] ${req.method} ${req.path} ${res.statusCode} ${duration}ms`);
  });

  next();
}

module.exports = { requestLogger };
