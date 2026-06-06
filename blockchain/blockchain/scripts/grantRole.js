const { ethers } = require("ethers");
const contractConfig = require("../../api/src/blockchain/contract.json");

async function main() {
  const provider = new ethers.JsonRpcProvider("https://rpc-amoy.polygon.technology");
  
  // Deployer wallet (has admin role)
  const deployer = new ethers.Wallet("80c8af5895c08e98ea9cbfadec0b25ffef3d1fb54f4d27fcf8ef23e7469d4e88", provider);

  // Minter wallet address (from your api .env MINTER_PRIVATE_KEY derived address)
  const MINTER_WALLET = "0x0e8bbD8d32454B3186057a8Ee7f9c0b974895cEb";
// console.log("Minter address:", minterWallet.address);

  const token = new ethers.Contract(contractConfig.address, contractConfig.abi, deployer);

  const MINTER_ROLE = await token.MINTER_ROLE();
  const tx = await token.grantRole(MINTER_ROLE, MINTER_WALLET);
  await tx.wait();

  console.log("✅ MINTER_ROLE granted to:", MINTER_WALLET);
}

main().catch(console.error);