// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {FunctionsClient} from "@chainlink/contracts@1.2.0/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import {ConfirmedOwner} from "@chainlink/contracts@1.2.0/src/v0.8/shared/access/ConfirmedOwner.sol";
import {FunctionsRequest} from "@chainlink/contracts@1.2.0/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";

import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import { IERC20 } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol';

contract AllocatorEVM is FunctionsClient, ConfirmedOwner, AxelarExecutable {
    using FunctionsRequest for FunctionsRequest.Request;

    bytes32 public s_lastRequestId;
    bytes public s_lastResponse;
    bytes public s_lastError;
    string public s_source;

    string public destinationChain;
    string public destinationAddress;
    IAxelarGasService public immutable gasService;
    // string public message;
    // string public sourceChain;
    // string public sourceAddress;
    // event Executed(bytes32 commandId, string _from, string _message);

    error UnexpectedRequestID(bytes32 requestId);

    event Response(bytes32 indexed requestId, bytes response, bytes err);

    // axelar sepolia gatawat 0xe432150cce91c13a887f7D836923d5597adD8E31
    // axelar sepolia gas receiver 0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6   
    constructor(
        address router,
        address _gateway, address _gasReceiver
    ) FunctionsClient(router) ConfirmedOwner(msg.sender) AxelarExecutable(_gateway) {
        gasService = IAxelarGasService(_gasReceiver);
    }

    function setSource(string memory source) external onlyOwner {
        s_source = source;
    }

    function setDestinationChain(string memory destination) external onlyOwner {
        destinationChain = destination;
    }

    function setDestinationAddress(string memory destination) external onlyOwner {
        destinationAddress = destination;
    }

    /**
     * @notice Send a simple request
     * @param encryptedSecretsUrls Encrypted URLs where to fetch user secrets
     * @param donHostedSecretsSlotID Don hosted secrets slotId
     * @param donHostedSecretsVersion Don hosted secrets version
     * @param args List of arguments accessible from within the source code
     * @param bytesArgs Array of bytes arguments, represented as hex strings
     * @param subscriptionId Billing ID
     */
    function sendRequest(
        bytes memory encryptedSecretsUrls,
        uint8 donHostedSecretsSlotID,
        uint64 donHostedSecretsVersion,
        string[] memory args,
        bytes[] memory bytesArgs,
        uint64 subscriptionId,
        uint32 gasLimit,
        bytes32 donID
    ) external returns (bytes32 requestId) {
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(s_source);
        if (encryptedSecretsUrls.length > 0)
            req.addSecretsReference(encryptedSecretsUrls);
        else if (donHostedSecretsVersion > 0) {
            req.addDONHostedSecrets(
                donHostedSecretsSlotID,
                donHostedSecretsVersion
            );
        }
        if (args.length > 0) req.setArgs(args);
        if (bytesArgs.length > 0) req.setBytesArgs(bytesArgs);
        s_lastRequestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            gasLimit,
            donID
        );
        return s_lastRequestId;
    }

    /**
     * @notice Store latest result/error
     * @param requestId The request ID, returned by sendRequest()
     * @param response Aggregated response from the user code
     * @param err Aggregated error from the user code or from the execution pipeline
     * Either response or error parameter will be set, but never both
     */
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId);
        }
        s_lastResponse = response;
        s_lastError = err;
        emit Response(requestId, s_lastResponse, s_lastError);
    }

    function setRemoteValue() external payable {
        require(msg.value > 0, 'Gas payment is required');

        // bytes memory payload = abi.encode(_message);
        gasService.payNativeGasForContractCall{ value: msg.value }(
            address(this),
            destinationChain,
            destinationAddress,
            s_lastResponse,
            msg.sender
        );
        gateway().callContract(destinationChain, destinationAddress, s_lastResponse);
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
    }
}
