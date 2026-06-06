/**
 * routes/index.js — all API routes wired up here
 */

const express = require("express");
const router = express.Router();
const { requireApiKey } = require("../middleware/auth");
const {
  validateCreateWallet,
  validateIssueReward,
  validateDeductReward,
  validateDeactivateUser,
} = require("../middleware/validate");
const walletController = require("../controllers/walletController");
const rewardController = require("../controllers/rewardController");

// All routes require a valid API key
router.use(requireApiKey);

// Wallet
router.post("/wallet/create", validateCreateWallet, walletController.createWallet);
router.get("/wallet/:userId/balance", walletController.getBalance);
router.post("/wallet/:userId/deactivate", validateDeactivateUser, walletController.deactivateUser);

// Rewards
router.post("/rewards/issue", validateIssueReward, rewardController.issueReward);
router.post("/rewards/deduct", validateDeductReward, rewardController.deductReward);

module.exports = router;
