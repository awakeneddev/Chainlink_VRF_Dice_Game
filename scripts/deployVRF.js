import pkg from "hardhat";
// Load environment variables
const { ethers } = pkg;
async function main() {
  /// vrf settings
  const subscriptionId = process.env.SUBSCRIPTION_ID;
  const vrfCoordinator = process.env.VRF_COORDINATOR;
  const keyHash = process.env.KEY_HASH;
  const requestConfirmations = 3;
  const callbackGasLimit = 100000;
  const numWords = 1;

  if (!subscriptionId) {
    throw new Error("SUBSCRIPTION_ID is not set in .env file");
  }

  console.log("Deploying VRF Handler contract...");

  // Deploy contract with constructor argument
  const vrfFactory = await ethers.getContractFactory("VRFHandler");
  const contract = await vrfFactory.deploy(
    vrfCoordinator,
    subscriptionId,
    keyHash,
    callbackGasLimit,
    requestConfirmations,
    numWords
  );

  // Wait for deployment to complete
  await contract.waitForDeployment();

  // Get contract address
  const address = await contract.getAddress();
  console.log(`DiceRollGame deployed at: ${address}`);
}

// Run deployment
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error deploying contract:", error);
    process.exit(1);
  });
