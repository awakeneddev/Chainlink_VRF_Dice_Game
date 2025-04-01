// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract VRFHandler is VRFConsumerBaseV2Plus {
    address public diceGame;
    uint256 public s_subscriptionId;
    bytes32 public s_keyHash;
    uint32 public callbackGasLimit;
    uint16 public requestConfirmations;
    uint32 public numWords;

    mapping(uint256 => address) public requestToPlayer;

    event RandomnessRequested(uint256 indexed requestId, address indexed player);
    event RandomnessFulfilled(uint256 indexed requestId, address indexed player, uint256[] randomWords);

    constructor(
        address _vrfCoordinator,
        uint256 _subscriptionId,
        bytes32 _keyHash,
        uint32 _callbackGasLimit,
        uint16 _requestConfirmations,
        uint32 _numWords
    ) VRFConsumerBaseV2Plus(_vrfCoordinator) {
        s_subscriptionId = _subscriptionId;
        s_keyHash = _keyHash;
        callbackGasLimit = _callbackGasLimit;
        requestConfirmations = _requestConfirmations;
        numWords = _numWords;
    }

    function setDiceGame(address _diceGame) external {
        require(diceGame == address(0), "DiceGame already set");
        diceGame = _diceGame;
    }

    function requestRandomness(address player) external returns (uint256 requestId) {
        require(msg.sender == diceGame, "Only DiceGame can request");
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
        requestToPlayer[requestId] = player;
        emit RandomnessRequested(requestId, player);
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] calldata _randomWords) internal override {
        address player = requestToPlayer[_requestId];
        require(player != address(0), "Request not found");
        emit RandomnessFulfilled(_requestId, player, _randomWords);
        // Call back to DiceRollGameGame with the result
        (bool success, ) = diceGame.call(
            abi.encodeWithSignature("handleFulfilledRandomWords(uint256,uint256[])", _requestId, _randomWords)
        );
        require(success, "Callback failed");
    }
}