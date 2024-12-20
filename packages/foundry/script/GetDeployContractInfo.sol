// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol"; 

using stdJson for string;

interface IERC20 {
    function name() external view returns (string memory);
}

contract GetContractInfo is Script {
    function run() external returns (bytes memory) {
        string memory contractAddressStr = vm.envString("CONTRACT_ADDRESS");
        address contractAddress = vm.parseAddress(contractAddressStr);

        string memory deployTxHashStr = vm.envString("DEPLOY_TX_HASH");

        // 使用vm.rpc 和 eth_getTransactionByHash 获取交易信息
        bytes memory txInfoStr = vm.rpc("eth_getTransactionByHash", abi.encode(deployTxHashStr));
        console.log(txInfoStr);

        string memory txInfoJson = stdJson.parseRaw(txInfoStr);

        string memory result = stdJson.object();
        result.addMember("contractName", stdJson.fromString(IERC20(contractAddress).name()));
        result.addMember("contractAddress", stdJson.fromString(contractAddressStr));
        result.addMember("transactionInfo", txInfoJson.getObject(0)); // 获取第一个元素，即交易信息


        bytes memory resultBytes = stdJson.serialize(result);

        string memory filename = string.concat(contractAddressStr, ".json");
        vm.writeFile(filename, resultBytes);

        return resultBytes;
    }
}