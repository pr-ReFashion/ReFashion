const rewardService = require("../services/rewardService");
const db = require("../models/db");

exports.issueReward = async (req, res) => {
  try {
    const { userId, amount, rewardEventId } = req.body;

    if (!userId || !amount || !rewardEventId) {
      return res.status(400).json({ error: "userId, amount, rewardEventId are required" });
    }
    if (typeof amount !== "number" || amount <= 0) {
      return res.status(400).json({ error: "amount must be a positive number" });
    }

    const userResult = await db.query(
      "SELECT wallet_address FROM users WHERE id = $1 AND is_active = TRUE",
      [userId]
    );
    if (userResult.rows.length === 0) {
      return res.status(404).json({ error: "User wallet not found. Create wallet first." });
    }

    const walletAddress = userResult.rows[0].wallet_address;
    console.log(`Issuing reward: userId=${userId}, walletAddress=${walletAddress}, amount=${amount}, rewardEventId=${rewardEventId}`);
    const result = await rewardService.issueReward({
      userId,
      walletAddress,
      amount,
      rewardEventId,
    });

    const status = result.duplicate ? 200 : 201;
    res.status(status).json(result);
  } catch (err) {
    console.error("issueReward error:", err);
    res.status(500).json({ error: "Failed to issue reward", detail: err.message });
  }
};

exports.deductReward = async (req, res) => {
  try {
    const { userId, amount, rewardEventId } = req.body;

    if (!userId || !amount || !rewardEventId) {
      return res.status(400).json({ error: "userId, amount, rewardEventId are required" });
    }
    if (typeof amount !== "number" || amount <= 0) {
      return res.status(400).json({ error: "amount must be a positive number" });
    }

    const userResult = await db.query(
      "SELECT wallet_address FROM users WHERE id = $1 AND is_active = TRUE",
      [userId]
    );
    if (userResult.rows.length === 0) {
      return res.status(404).json({ error: "User wallet not found" });
    }

    const walletAddress = userResult.rows[0].wallet_address;
    console.log(`Deducting reward: userId=${userId}, walletAddress=${walletAddress}, amount=${amount}, rewardEventId=${rewardEventId}`);
    const result = await rewardService.deductReward({
      userId,
      walletAddress,
      amount,
      rewardEventId,
    });

    res.status(200).json(result);
  } catch (err) {
    console.error("deductReward error:", err);
    res.status(500).json({ error: "Failed to deduct reward", detail: err.message });
  }
};
