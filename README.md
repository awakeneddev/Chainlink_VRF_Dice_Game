# 🎲 Dice Roll Game - Blockchain Powered (Chainlink VRF + Hardhat + React)

This is a **decentralized dice rolling game** built on **Ethereum**, ensuring **provable randomness** using **Chainlink VRF (Verifiable Random Function)**. The project includes a Solidity smart contract deployed with **Hardhat**, and a React-based frontend powered by **Ethers.js** for seamless interaction.

![image](https://github.com/user-attachments/assets/c4693ad1-8530-4a84-ad74-059ef4a8ec80)

## 🚀 Features
✅ **Fair & Transparent** - Uses Chainlink VRF for **provably random dice rolls**  
✅ **Decentralized** - Runs on **Ethereum blockchain**  
✅ **MetaMask Integration** - Connects with **MetaMask** for transactions  
✅ **Live Dice Landing** - Frontend updates when the dice roll is completed  
✅ **Optimized Smart Contract** - Efficient gas usage & event-driven architecture  
✅ **Upgradeable Architecture** - Uses **UUPSUpgradeable** for seamless contract upgrades  
✅ **Separate VRF Handler** - Offloads randomness handling to a dedicated contract for **better modularity**  
✅ **Fallback Mechanism** - Stores pending randomness requests to prevent data loss in case of failures  

## 🏰 Tech Stack
| Layer       | Technology  |
|------------|------------|
| **Smart Contract** | Solidity, Chainlink VRF, Hardhat |
| **Frontend** | React, Ethers.js, Vite |
| **Blockchain** | Ethereum (Sepolia Testnet) |
| **Wallet** | MetaMask |

## 📝 Smart Contract Overview
The smart contract ensures **fair dice rolls** by:
1. **Requesting randomness** from Chainlink VRF via a separate VRF handler contract.
2. **Storing requests** in a mapping to prevent lost requests.
3. **Emitting an event** when the dice lands.
4. **Allowing contract upgrades** via UUPS proxy pattern.

```solidity
event DiceRolled(uint256 indexed requestId, address indexed player);
event DiceLanded(uint256 indexed requestId, address indexed player, uint256 indexed value);
```

## 🚀 Getting Started

### 📌 Prerequisites
- **Node.js** (v16+)
- **MetaMask** extension installed
- **Hardhat** installed globally (`npm install -g hardhat`)

### 🔧 Setup & Installation
1. **Clone the Repository**
   ```sh
   git clone https://github.com/awakeneddev/Chainlink_VRF_Dice_Game.git
   cd Chainlink_VRF_Dice_Game
   ```

2. **Install Dependencies**
   ```sh
   npm install
   ```

3. **Set Up Environment Variables**
   Create a `.env` file in the root directory and add:

    ```sh
   ALCHEMY_KEY=YOUR_ALCHEMY_KEY
   PRIVATE_KEY=YOUR_PRIVATE_KEY
   ETHER_SCAN_API_KEY=YOUR_ETHER_SCAN_API_KEY
   SUBSCRIPTION_ID=YOUR_CHAIN_LINK_SUBSCRIPTION_ID
   KEY_HASH=YOUR_CHAIN_LINK_KEY_HASH
   VRF_COORDINATOR=YOUR_CHAIN_LINK_VRF_COORDINATOR
   VRF_HANDLER_CONTRACT_ADDRESS=YOUR_DEPLOYED_VRF_HANDLER_CONTRACT_ADDRESS
   VITE_CONTRACT_ADDRESS=YOUR_DICE_GAME_DEPLOYED_PROXY_ADDRESS
   ```

## 🎲 Running the Game

### 🔹 Deploy Smart Contract
1. **Compile the Contract**
   ```sh
   npx hardhat compile
   ```

2. **Deploy VRF Handler & Dice Game Contracts**
   ```sh
   npx hardhat run --network sepolia scripts/deployVRFHandler.js
   npx hardhat run --network sepolia scripts/deployDiceGame.js
   ```

3. **Save the deployed contract addresses** and update `.env` with:
   ```sh
   VRF_HANDLER_CONTRACT_ADDRESS=your_deployed_vrf_handler_address
   VITE_CONTRACT_ADDRESS=your_deployed_dice_game_address
   ```

### 🔹 Start the Frontend
```sh
npm run dev
```

## 🎮 How It Works
1. **User clicks 'Roll Dice'**
2. **MetaMask prompts for transaction**
3. **DiceGame contract requests randomness from VRFHandler**
4. **VRFHandler communicates with Chainlink VRF to fetch randomness**
5. **Event emitted when dice lands**
6. **Frontend updates with the result**

## 🤝 Contributing
We welcome contributions! To contribute:
1. **Fork** this repository.
2. **Create** a feature branch (`git checkout -b feature-xyz`).
3. **Commit** your changes (`git commit -m "Add feature xyz"`).
4. **Push** to your fork (`git push origin feature-xyz`).
5. **Submit** a Pull Request.

## 📜 License
This project is licensed under the **MIT License**.

### 🎲 Play the Game Now!  
🚀 **Live Demo**: [Coming Soon]

