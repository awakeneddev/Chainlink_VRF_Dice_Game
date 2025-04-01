// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./VrfHandler.sol";

contract DiceGame is Initializable, UUPSUpgradeable {
    address internal owner;
    event DiceRolled(uint256 indexed requestId, address indexed player);
    event DiceLanded(
        uint256 indexed requestId,
        address indexed player,
        uint256 value
    );

    struct RollRequest {
        address player;
        bool fulfilled;
        uint256 value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Authorized");
        _;
    }

    mapping(uint256 => RollRequest) public rollRequests;
    uint256 public lastDiceRequest;
    address public vrfHandler;

    function initialize(address _vrfHandler) public initializer {
        __UUPSUpgradeable_init();
        vrfHandler = _vrfHandler;
        owner = msg.sender;
    }

    function rollDice() external returns (uint256 requestId) {
        requestId = VRFHandler(vrfHandler).requestRandomness(msg.sender);
        rollRequests[requestId] = RollRequest({
            player: msg.sender,
            fulfilled: false,
            value: 0
        });
        lastDiceRequest = requestId;
        emit DiceRolled(requestId, msg.sender);
    }

    function handleFulfilledRandomWords(
        uint256 _requestId,
        uint256[] calldata _randomWords
    ) external {
        require(msg.sender == vrfHandler, "Unauthorized");
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
        require(rollRequests[_requestId].player == msg.sender, "Not player");
        return (
            rollRequests[_requestId].value,
            rollRequests[_requestId].fulfilled
        );
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}
