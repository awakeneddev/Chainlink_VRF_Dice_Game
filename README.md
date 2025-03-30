
# 🎲 Dice Roll Game - Blockchain Powered (Chainlink VRF + Hardhat + React)

This is a **decentralized dice rolling game** built on **Ethereum**, ensuring **provable randomness** using **Chainlink VRF (Verifiable Random Function)**. The project includes a Solidity smart contract deployed with **Hardhat**, and a React-based frontend powered by **Ethers.js** for seamless interaction.


![image](https://github.com/user-attachments/assets/c4693ad1-8530-4a84-ad74-059ef4a8ec80)

## 🚀 Features
✅ **Fair & Transparent** - Uses Chainlink VRF for **provably random dice rolls**  
✅ **Decentralized** - Runs on **Ethereum blockchain**  
✅ **MetaMask Integration** - Connects with **MetaMask** for transactions  
✅ **Live Dice Landing** - Frontend updates when the dice roll is completed  
✅ **Optimized Smart Contract** - Efficient gas usage & event-driven architecture  



## 🏗️ Tech Stack
| Layer       | Technology  |
|------------|------------|
| **Smart Contract** | Solidity, Chainlink VRF, Hardhat |
| **Frontend** | React, Ethers.js, Vite |
| **Blockchain** | Ethereum (Sepolia Testnet) |
| **Wallet** | MetaMask |


## 📜 Smart Contract Overview
The smart contract ensures **fair dice rolls** by:
1. **Requesting randomness** from Chainlink VRF.
2. **Emitting an event** when the dice lands.
3. **Storing and verifying** roll results.


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
   SUBSCRIPTION_ID=your_chainlink_subscription_id
   VRF_COORDINATOR=your_vrf_coordinator_address
   KEY_HASH=your_chainlink_key_hash
   VITE_CONTRACT_ADDRESS=your_deployed_contract_address
   ```



## 🎲 Running the Game

### 🔹 Deploy Smart Contract
1. **Compile the Contract**
   ```sh
   npx hardhat compile
   ```

2. **Deploy on Sepolia Testnet**
   ```sh
   npx hardhat run --network sepolia scripts/deploy.js
   ```

3. **Save the deployed contract address** and update `.env` with:
   ```sh
   VITE_CONTRACT_ADDRESS=your_deployed_contract_address
   ```

### 🔹 Start the Frontend
```sh
npm run dev
```



## 🎯 How It Works
1. **User clicks 'Roll Dice'**
2. **MetaMask prompts for transaction**
3. **Chainlink VRF generates a random number**
4. **Event emitted when dice lands**
5. **Frontend updates with the result**



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
