import pkg from "hardhat";
// Load environment variables
const { ethers } = pkg;
async function main() {
  // Ensure the environment variable is set
  const subscriptionId = process.env.SUBSCRIPTION_ID;
  if (!subscriptionId) {
    throw new Error("SUBSCRIPTION_ID is not set in .env file");
  }

  console.log("Deploying DiceRollGame contract...");

  // Deploy contract with constructor argument
  const contractFactory = await ethers.getContractFactory("DiceRollGame");
  const contract = await contractFactory.deploy(subscriptionId);

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
