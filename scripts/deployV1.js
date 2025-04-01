import pkg from "hardhat";
// Load environment variables
const { ethers, upgrades } = pkg;

async function main() {
  // 1. Communicating with DiceGame COntract
  const DiceGameFactory = await ethers.getContractFactory("DiceGame");
  console.log("Dice game deployment started");
  const vrfHandlerAddress = process.env.VRF_HANDLER_CONTRACT_ADDRESS;

  // deploying contract with deploy proxy with initializer argument
  const diceGameContract = await upgrades.deployProxy(DiceGameFactory, [
    vrfHandlerAddress,
  ]);

  // waiting for deployment confirmation
  console.log("Waiting for deployment confirmation");
  await diceGameContract.waitForDeployment();
  const proxyAddress = await diceGameContract.getAddress();
  console.log("Lottery contract deployed to : ", proxyAddress);

  // 2. Connecting to existing VRF Handler
  const vrfHandlerFactory = await ethers.getContractFactory("VRFHandler");
  const vrfHandler = vrfHandlerFactory.attach(vrfHandlerAddress);

  // 3. Setting DiceGame address in VRFHandler
  const tx = await vrfHandler.setDiceGame(proxyAddress);
  await tx.wait();
  console.log("VRFHandler configured with DiceGame address:", proxyAddress);
}
// Run deployment
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error deploying contract:", error);
    process.exit(1);
  });
