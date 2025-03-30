// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Importing Chainlink VRF and OpenZeppelin Ownable contract for access control
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DiceRollGame
 * @dev A smart contract that uses Chainlink VRF to simulate a dice roll.
 */
contract DiceRollGame is VRFConsumerBaseV2Plus {
    // Events to notify when dice is rolled and landed with results
    event DiceRolled(uint256 indexed requestId, address indexed player);
    event DiceLanded(uint256 indexed requestId, address indexed player, uint256 indexed value);

    /**
     * @dev Struct to store information about each dice roll request
     * @param player Address of the player who initiated the request
     * @param fulfilled Whether the random number has been generated
     * @param value The final dice value (1-6) after VRF fulfillment
     */
    struct RollRequest {
        address player;
        bool fulfilled;
        uint256 value;
    }

    // Mapping request ID to roll request details
    mapping(uint256 => RollRequest) public rollRequests;
    uint256 lastDiceRequest; // Stores the last request ID

    // Chainlink VRF configuration
    uint256 s_subscriptionId; // Subscription ID for Chainlink VRF
    address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B; // Sepolia VRF Coordinator
    bytes32 s_keyHash = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae; // Key hash for VRF
    uint32 callbackGasLimit = 1000000; // Gas limit for VRF callback
    uint16 requestConfirmations = 3; // Number of confirmations required
    uint32 numWords = 1; // Number of random numbers requested

    /**
     * @dev Constructor that initializes the VRF subscription ID
     * @param subscriptionId The Chainlink VRF subscription ID
     */
    constructor(uint256 subscriptionId) VRFConsumerBaseV2Plus(vrfCoordinator) {
        s_subscriptionId = subscriptionId;
    }

    /**
     * @dev Function to roll the dice, requests a random number from Chainlink VRF
     * @return requestId The request ID assigned to this roll
     */
    function rollDice() external returns (uint256 requestId) {
        // Request a random number from Chainlink VRF
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );

        // Store the request details
        rollRequests[requestId] = RollRequest({
            player: msg.sender,
            fulfilled: false,
            value: 0
        });

        lastDiceRequest = requestId; // Save last request ID
        emit DiceRolled(requestId, msg.sender); // Emit event
    }

    /**
     * @dev Callback function called by Chainlink VRF when a random number is generated
     * @param _requestId The request ID associated with this roll
     * @param _randomWords The array of random numbers returned (only one used here)
     */
    function fulfillRandomWords(uint256 _requestId, uint256[] calldata _randomWords) internal override {
        require(rollRequests[_requestId].player != address(0), "Invalid Request"); // Ensure request exists

        // Convert random number to a dice roll result (1-6)
        uint256 diceResult = (_randomWords[0] % 6) + 1;

        // Update the request record with the result
        rollRequests[_requestId].fulfilled = true;
        rollRequests[_requestId].value = diceResult;

        emit DiceLanded(_requestId, rollRequests[_requestId].player, diceResult); // Emit event
    }

    /**
     * @dev Function to retrieve the dice result
     * @param _requestId The request ID of the roll
     * @return result The dice roll value (1-6)
     * @return fulfilled Whether the request has been fulfilled
     */
    function getDiceResult(uint256 _requestId) external view returns (uint256 result, bool fulfilled) {
        require(rollRequests[_requestId].player == msg.sender, "Only the player can get the result"); // Ensure caller is the player
        return (rollRequests[_requestId].value, rollRequests[_requestId].fulfilled); // Return result
    }
}
