//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/AllocatorEVM.sol";
import "./DeployHelpers.s.sol";

contract DeployAllocatorEVMContract is ScaffoldETHDeploy {
  // use `deployer` from `ScaffoldETHDeploy`
  function run() external ScaffoldEthDeployerRunner {
    AllocatorEVM yourContract = new AllocatorEVM(deployer);
    console.logString(
      string.concat(
        "AllocatorEVM deployed at: ", vm.toString(address(yourContract))
      )
    );
  }
}
