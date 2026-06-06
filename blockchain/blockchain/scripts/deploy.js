/**
 * deploy.js
 *
 * Deploys ReFashionToken and writes the contract address + ABI to
 * ../../api/src/blockchain/contract.json so the API can pick it up
 * without manual copy-paste.
 */

const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("=".repeat(50));
  console.log("Deploying ReFashionToken");
  console.log("Deployer:", deployer.address);
  console.log(
    "Balance:",
    ethers.formatEther(await ethers.provider.getBalance(deployer.address)),
    "ETH/MATIC"
  );
  console.log("=".repeat(50));

  // Deploy — pass deployer as admin so it holds all roles initially.
  // In production you'd pass a dedicated backend wallet address here.
  const ReFashionToken = await ethers.getContractFactory("ReFashionToken");
  const token = await ReFashionToken.deploy(deployer.address);
  await token.waitForDeployment();

  const contractAddress = await token.getAddress();
  console.log("\n✅ ReFashionToken deployed to:", contractAddress);

  // ── Write config for the API ─────────────────────────────────────────────
  const artifact = await artifacts.readArtifact("ReFashionToken");

  const outputDir = path.resolve(__dirname, "../../api/src/blockchain");
  fs.mkdirSync(outputDir, { recursive: true });

  const contractConfig = {
    address: contractAddress,
    network: hre.network.name,
    deployedAt: new Date().toISOString(),
    abi: artifact.abi,
  };

  const outputPath = path.join(outputDir, "contract.json");
  fs.writeFileSync(outputPath, JSON.stringify(contractConfig, null, 2));
  console.log("📄 Contract config written to:", outputPath);

  // ── Quick smoke test ─────────────────────────────────────────────────────
  console.log("\n── Smoke test ──────────────────────────────────────────────");
  const testAmount = ethers.parseEther("100");
  const testEventId = "smoke-test-001";

  // Mint 100 RFT to deployer wallet
  const mintTx = await token.mint(deployer.address, testAmount, testEventId);
  await mintTx.wait();
  console.log("Minted 100 RFT. Tx:", mintTx.hash);

  const balance = await token.balanceOf(deployer.address);
  console.log("Balance after mint:", ethers.formatEther(balance), "RFT");

  // Burn 50 RFT
  const burnTx = await token.burn(deployer.address, ethers.parseEther("50"), "smoke-test-002");
  await burnTx.wait();
  console.log("Burned 50 RFT.  Tx:", burnTx.hash);

  const balanceAfterBurn = await token.balanceOf(deployer.address);
  console.log("Balance after burn:", ethers.formatEther(balanceAfterBurn), "RFT");

  console.log("\n✅ Smoke test passed");
  console.log("=".repeat(50));
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
