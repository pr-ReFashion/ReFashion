/**
 * services/walletService.js
 *
 * Handles custodial wallet creation.
 *
 * Security notes:
 * - Private keys are encrypted with AES-256 using ENCRYPTION_KEY from env.
 * - Keys are never logged or returned in API responses.
 * - In production, consider replacing this with AWS KMS or HashiCorp Vault.
 */

const { ethers } = require("ethers");
const crypto = require("crypto");

const ALGORITHM = "aes-256-cbc";
const IV_LENGTH = 16;

function getEncryptionKey() {
  const key = process.env.ENCRYPTION_KEY;
  if (!key || key.length < 32) {
    throw new Error("ENCRYPTION_KEY must be at least 32 characters");
  }
  // Use first 32 bytes as key
  return Buffer.from(key.slice(0, 32));
}

function encryptPrivateKey(privateKey) {
  const iv = crypto.randomBytes(IV_LENGTH);
  const cipher = crypto.createCipheriv(ALGORITHM, getEncryptionKey(), iv);
  const encrypted = Buffer.concat([cipher.update(privateKey), cipher.final()]);
  return iv.toString("hex") + ":" + encrypted.toString("hex");
}

function decryptPrivateKey(encryptedKey) {
  const [ivHex, encryptedHex] = encryptedKey.split(":");
  const iv = Buffer.from(ivHex, "hex");
  const encrypted = Buffer.from(encryptedHex, "hex");
  const decipher = crypto.createDecipheriv(ALGORITHM, getEncryptionKey(), iv);
  const decrypted = Buffer.concat([decipher.update(encrypted), decipher.final()]);
  return decrypted.toString();
}

/**
 * Creates a new custodial wallet.
 * Returns only the address and encrypted key — never the raw private key.
 */
function createWallet() {
  const wallet = ethers.Wallet.createRandom();
  return {
    address: wallet.address,
    encryptedPrivateKey: encryptPrivateKey(wallet.privateKey),
  };
}

/**
 * Reconstructs an ethers.Wallet from the stored encrypted key.
 * Used internally when signing user transactions.
 */
function loadWallet(encryptedPrivateKey, provider) {
  const privateKey = decryptPrivateKey(encryptedPrivateKey);
  return new ethers.Wallet(privateKey, provider);
}

module.exports = { createWallet, loadWallet, encryptPrivateKey, decryptPrivateKey };
