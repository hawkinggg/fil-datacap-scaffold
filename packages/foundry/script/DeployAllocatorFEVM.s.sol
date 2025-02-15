//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "../contracts/AllocatorFEVM.sol";
import "./DeployHelpers.s.sol";

contract DeployAllocatorFEVMContract is ScaffoldETHDeploy {
  // use `deployer` from `ScaffoldETHDeploy`
  function run() external ScaffoldEthDeployerRunner {
    // sepolia
    address gateway = 0x999117D44220F33e0441fbAb2A5aDB8FF485c54D;
    AllocatorFEVM yourContract = new AllocatorFEVM(gateway);
    console.logString(
      string.concat(
        "AllocatorFEVM deployed at: ", vm.toString(address(yourContract))
      )
    );
  }
}
