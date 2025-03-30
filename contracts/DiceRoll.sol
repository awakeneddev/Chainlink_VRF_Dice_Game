// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DiceRollGame is VRFConsumerBaseV2Plus {
    event DiceRolled(uint256 indexed requestId, address indexed player);
    event DiceLanded(
        uint256 indexed requestId,
        address indexed player,
        uint256 indexed value
    );
    struct RollRequest {
        address player;
        bool fulfilled;
        uint256 value;
    }

    mapping(uint256 => RollRequest) public rollRequests;
    uint256 lastDiceRequest;

    // VRF Settings
    uint256 s_subscriptionId;
    address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    bytes32 s_keyHash =
        0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 callbackGasLimit = 1000000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;

    constructor(
        uint256 subscriptionId
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        s_subscriptionId = subscriptionId;
    }

    function rollDice() external returns (uint256 requestId) {
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

        rollRequests[requestId] = RollRequest({
            player: msg.sender,
            fulfilled: false,
            value: 0
        });

        lastDiceRequest = requestId;
        emit DiceRolled(requestId, msg.sender);
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] calldata _randomWords
    ) internal override {
        require(
            rollRequests[_requestId].player != address(0),
            "Invalid Request"
        );
        uint256 diceResult = (_randomWords[0] % 6) + 1;
        rollRequests[_requestId].fulfilled = true;
        rollRequests[_requestId].value = diceResult;
        emit DiceLanded(
            _requestId,
            rollRequests[_requestId].player,
            diceResult
        );
    }

    function getDiceResult(
        uint256 _requestId
    ) external view returns (uint256 result, bool fulfilled) {
        require(
            rollRequests[_requestId].player == msg.sender,
            "Only the player can get the result"
        );

        return (
            rollRequests[_requestId].value,
            rollRequests[_requestId].fulfilled
        );
    }
}
