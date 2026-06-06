/**
 * blockchain/client.js
 *
 * Single source of truth for contract interaction.
 * All other services import from here — never instantiate ethers directly elsewhere.
 *
 * Design notes:
 * - The minter wallet is the hot wallet that signs all mint/burn transactions.
 *   Its private key is loaded from env (never hardcoded).
 * - contract.json is written by the Hardhat deploy script automatically.
 *   No manual ABI copy-paste required.
 */

const { ethers } = require("ethers");
const contractConfig = require("./contract.json");

let _provider = null;
let _minterWallet = null;
let _contract = null;

function getProvider() {
  if (!_provider) {
    _provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
  }
  return _provider;
}

function getMinterWallet() {
  if (!_minterWallet) {
    if (!process.env.MINTER_PRIVATE_KEY) {
      throw new Error("MINTER_PRIVATE_KEY not set in environment");
    }
    _minterWallet = new ethers.Wallet(process.env.MINTER_PRIVATE_KEY, getProvider());
  }
  return _minterWallet;
}

function getContract() {
  if (!_contract) {
    _contract = new ethers.Contract(
      contractConfig.address,
      contractConfig.abi,
      getMinterWallet()
    );
  }
  return _contract;
}

/**
 * Mint tokens to a user's custodial wallet.
 * amount is in whole tokens (e.g. 50 = 50 RFT).
 */
async function mintTokens(toAddress, amount, rewardEventId) {
  const contract = getContract();
  const amountWei = ethers.parseEther(String(amount));
  const tx = await contract.mint(toAddress, amountWei, rewardEventId);
  const receipt = await tx.wait();
  return { txHash: receipt.hash, blockNumber: receipt.blockNumber };
}

/**
 * Burn tokens from a user's custodial wallet.
 */
async function burnTokens(fromAddress, amount, rewardEventId) {
  const contract = getContract();
  const amountWei = ethers.parseEther(String(amount));
  const tx = await contract.burn(fromAddress, amountWei, rewardEventId);
  const receipt = await tx.wait();
  return { txHash: receipt.hash, blockNumber: receipt.blockNumber };
}

/**
 * Returns balance in whole tokens (not wei).
 */
async function getBalance(walletAddress) {
  const contract = getContract();
  const balanceWei = await contract.balanceOf(walletAddress);
  return ethers.formatEther(balanceWei);
}

module.exports = { mintTokens, burnTokens, getBalance, getContract, getMinterWallet };
