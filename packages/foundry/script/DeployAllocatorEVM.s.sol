//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "../contracts/AllocatorEVM.sol";
import "./DeployHelpers.s.sol";

contract DeployAllocatorEVMContract is ScaffoldETHDeploy {
  // use `deployer` from `ScaffoldETHDeploy`
  function run() external ScaffoldEthDeployerRunner {
    // sepolia
    address router = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;
    address gateway = 0xe432150cce91c13a887f7D836923d5597adD8E31;
    address gasReceiver = 0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6;
    
    AllocatorEVM yourContract = new AllocatorEVM(router, gateway, gasReceiver);
    console.logString(
      string.concat(
        "AllocatorEVM deployed at: ", vm.toString(address(yourContract))
      )
    );
  }
}
