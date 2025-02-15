// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IERC20 } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol';
import {ConfirmedOwner} from "@chainlink/contracts@1.2.0/src/v0.8/shared/access/ConfirmedOwner.sol";

/**
 * @title CallContract
 * @notice Send a message from chain A to chain B and stores gmp message
 */
contract AllocatorFEVM is ConfirmedOwner, AxelarExecutable {
    string public message;
    string public sourceChain;
    string public sourceAddress;

    event Executing(bytes32 commandId, string _chain, string _addr, bytes _payload);
    event Executed(bytes32 commandId, string _from, string _message);

    error InvalidSourceChain(string chain);
    error InvalidSourceAddress(string addr);

    /**
     *
     * @param _gateway address of axl gateway on deployed chain
     * axelar fevm calibration gateway: 0x999117D44220F33e0441fbAb2A5aDB8FF485c54D
     * axelar fevm calibration gas receiver: 0xbe406f0189a0b4cf3a05c286473d23791dd44cc6
     */
    constructor(address _gateway) ConfirmedOwner(msg.sender) AxelarExecutable(_gateway) {}

    function setSourceChain(string memory _sourceChain) external onlyOwner {
        sourceChain = _sourceChain;
    }

    function setSourceAddress(string memory _sourceAddress) external onlyOwner {
        sourceAddress = _sourceAddress;
    }

    /**
     * @notice logic to be executed on dest chain
     * @dev this is triggered automatically by relayer
     * @param _sourceChain blockchain where tx is originating from
     * @param _sourceAddress address on src chain where tx is originating from
     * @param _payload encoded gmp message sent from src chain
     */
    function _execute(
        bytes32 commandId,
        string calldata _sourceChain,
        string calldata _sourceAddress,
        bytes calldata _payload
    ) internal override {
        emit Executing(commandId, _sourceChain, _sourceAddress, _payload);

        // if (keccak256(bytes(sourceChain)) != keccak256(bytes(_sourceChain))) {
        //     revert InvalidSourceChain(_sourceChain);
        // }
        // if(keccak256(bytes(sourceAddress)) != keccak256(bytes(_sourceAddress))) {
        //     revert InvalidSourceAddress(_sourceAddress);
        // }

        message = string(_payload);
        // emit Executed(commandId, sourceAddress, message);
    }
}
