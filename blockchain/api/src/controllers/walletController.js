const walletService = require("../services/walletService");
const rewardService = require("../services/rewardService");
const blockchain = require("../blockchain/client");
const db = require("../models/db");

function hasPositiveBalance(balance) {
  return Number(balance) > 0;
}

exports.createWallet = async (req, res) => {
  try {
    const { userId } = req.body;
    if (!userId) return res.status(400).json({ error: "userId is required" });

    // Check if an active wallet already exists for this user.
    const existing = await db.query(
      "SELECT wallet_address FROM users WHERE id = $1 AND is_active = TRUE",
      [userId]
    );
    if (existing.rows.length > 0) {
      return res.status(200).json({
        message: "Wallet already exists",
        walletAddress: existing.rows[0].wallet_address,
      });
    }

    const { address, encryptedPrivateKey } = walletService.createWallet();

    await db.query(
      `INSERT INTO users (id, wallet_address, encrypted_private_key, original_user_id, is_active, created_at)
       VALUES ($1, $2, $3, $1, TRUE, NOW())`,
      [userId, address, encryptedPrivateKey]
    );

    res.status(201).json({ walletAddress: address });
  } catch (err) {
    console.error("createWallet error:", err);
    res.status(500).json({ error: "Failed to create wallet" });
  }
};

exports.getBalance = async (req, res) => {
  try {
    const { userId } = req.params;

    const result = await db.query(
      "SELECT wallet_address FROM users WHERE id = $1 AND is_active = TRUE",
      [userId]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }

    const balance = await blockchain.getBalance(result.rows[0].wallet_address);
    res.json({ userId, balance, symbol: "RFT" });
  } catch (err) {
    console.error("getBalance error:", err);
    res.status(500).json({ error: "Failed to fetch balance" });
  }
};

exports.deactivateUser = async (req, res) => {
  try {
    const { userId } = req.params;
    const { rewardEventId } = req.body;

    const userResult = await db.query(
      "SELECT id, wallet_address FROM users WHERE id = $1 AND is_active = TRUE",
      [userId]
    );
    if (userResult.rows.length === 0) {
      return res.status(404).json({ error: "Active user wallet not found" });
    }

    const { wallet_address: walletAddress } = userResult.rows[0];
    const balance = await blockchain.getBalance(walletAddress);
    let burnResult = null;

    if (hasPositiveBalance(balance)) {
      burnResult = await rewardService.deductReward({
        userId,
        walletAddress,
        amount: balance,
        rewardEventId,
      });

      if (burnResult.duplicate) {
        return res.status(409).json({
          error: "rewardEventId was already used; provide a new rewardEventId for deactivation",
          burn: burnResult,
        });
      }

      if (burnResult.status !== "CONFIRMED") {
        return res.status(409).json({
          error: "Cannot deactivate user until balance burn is confirmed",
          burn: burnResult,
        });
      }
    }

    const archivedUserId = `${userId}:deactivated:${Date.now()}`;
    const deactivateResult = await db.query(
      `UPDATE users
       SET id = $1,
           original_user_id = COALESCE(original_user_id, $2),
           is_active = FALSE,
           deactivated_at = NOW()
       WHERE id = $2 AND is_active = TRUE
       RETURNING id, original_user_id, wallet_address, deactivated_at`,
      [archivedUserId, userId]
    );

    if (deactivateResult.rows.length === 0) {
      return res.status(409).json({ error: "User was already deactivated" });
    }

    res.status(200).json({
      message: "User deactivated",
      userId,
      archivedUserId: deactivateResult.rows[0].id,
      walletAddress,
      burnedAmount: hasPositiveBalance(balance) ? balance : "0.0",
      burn: burnResult,
      deactivatedAt: deactivateResult.rows[0].deactivated_at,
    });
  } catch (err) {
    console.error("deactivateUser error:", err);
    res.status(500).json({ error: "Failed to deactivate user", detail: err.message });
  }
};
