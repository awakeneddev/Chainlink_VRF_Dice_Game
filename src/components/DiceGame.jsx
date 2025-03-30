import { ethers } from "ethers";
import React, { useState, useEffect } from "react";
import { ABI } from "../utils/diceGame";

const DiceGame = () => {
  const [requestId, setRequestId] = useState(null);
  const [diceResult, setDiceResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [isLanding, setIsLanding] = useState(false);
  
  useEffect(() => {
    if (!window.ethereum) return;
    
    const provider = new ethers.BrowserProvider(window.ethereum);
    const contract = new ethers.Contract(
      import.meta.env.VITE_CONTRACT_ADDRESS,
      ABI,
      provider
    );
    
    const handleDiceLanded = (reqId, player, result) => {
      setRequestId(reqId.toString());
      setDiceResult(result);
      setIsLanding(false);
      setLoading(false);
    };
    
    contract.on("DiceLanded", handleDiceLanded);
    return () => contract.off("DiceLanded", handleDiceLanded);
  }, []);

  const handleRollDice = async () => {
    if (!window.ethereum) return alert("Please install MetaMask!");
    
    setLoading(true);
    setIsLanding(true);
    
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      await provider.send("eth_requestAccounts", []);
      const signer = await provider.getSigner();
      const contract = new ethers.Contract(import.meta.env.VITE_CONTRACT_ADDRESS, ABI, signer);
      
      const tx = await contract.rollDice();
      await tx.wait();
    } catch (err) {
      console.error("Error rolling dice:", err);
      setIsLanding(false);
      setLoading(false);
    }
  };


  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-900 text-white p-6">
      <h1 className="text-2xl font-bold mb-4">🎲 Chainlink VRF Dice Game</h1>
      <button
        onClick={handleRollDice}
        className="px-6 py-3 bg-blue-500 rounded-lg font-bold hover:bg-blue-600 transition"
        disabled={loading}
      >
        {loading ? "Rolling..." : "Roll Dice 🎲"}
      </button>

      {isLanding && !diceResult && (
        <p className="text-center font-medium mt-2">Dice is landing... Please wait.</p>
      )}

      {requestId && (
        <div className="mt-4 text-lg">
          <p>
            Request ID: <span className="text-green-400">{requestId}</span>
          </p>
        </div>
      )}

      {diceResult && !isLanding && (
        <div className="mt-4 text-xl">
          <p>
            🎲 Dice Landed on: <span className="text-yellow-400">{diceResult}</span>
          </p>
        </div>
      )}
    </div>
  );
};

export default DiceGame;
