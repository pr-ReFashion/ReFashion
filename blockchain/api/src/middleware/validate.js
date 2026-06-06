/**
 * middleware/validate.js
 *
 * Lightweight input validation for reward endpoints.
 * Keeps controllers clean — they only handle happy path.
 */

function validateIssueReward(req, res, next) {
  const { userId, amount, rewardEventId } = req.body;

  if (!userId || typeof userId !== "string" || userId.trim() === "") {
    return res.status(400).json({ error: "userId must be a non-empty string" });
  }
  if (!rewardEventId || typeof rewardEventId !== "string" || rewardEventId.trim() === "") {
    return res.status(400).json({ error: "rewardEventId must be a non-empty string" });
  }
  if (typeof amount !== "number" || !Number.isFinite(amount) || amount <= 0) {
    return res.status(400).json({ error: "amount must be a positive number" });
  }
  if (amount > 1_000_000) {
    return res.status(400).json({ error: "amount exceeds maximum single reward (1,000,000)" });
  }

  next();
}

function validateDeductReward(req, res, next) {
  const { userId, amount, rewardEventId } = req.body;

  if (!userId || typeof userId !== "string" || userId.trim() === "") {
    return res.status(400).json({ error: "userId must be a non-empty string" });
  }
  if (!rewardEventId || typeof rewardEventId !== "string" || rewardEventId.trim() === "") {
    return res.status(400).json({ error: "rewardEventId must be a non-empty string" });
  }
  if (typeof amount !== "number" || !Number.isFinite(amount) || amount <= 0) {
    return res.status(400).json({ error: "amount must be a positive number" });
  }

  next();
}

function validateCreateWallet(req, res, next) {
  const { userId } = req.body;

  if (!userId || typeof userId !== "string" || userId.trim() === "") {
    return res.status(400).json({ error: "userId must be a non-empty string" });
  }

  next();
}

function validateDeactivateUser(req, res, next) {
  const { userId } = req.params;
  const { rewardEventId } = req.body;

  if (!userId || typeof userId !== "string" || userId.trim() === "") {
    return res.status(400).json({ error: "userId must be a non-empty string" });
  }
  if (!rewardEventId || typeof rewardEventId !== "string" || rewardEventId.trim() === "") {
    return res.status(400).json({ error: "rewardEventId must be a non-empty string" });
  }

  next();
}

module.exports = {
  validateIssueReward,
  validateDeductReward,
  validateCreateWallet,
  validateDeactivateUser,
};
