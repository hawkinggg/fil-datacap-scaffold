//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./DeployHelpers.s.sol";
import { DeployYourContract } from "./DeployYourContract.s.sol";
import { DeployAllocatorEVMContract } from "./DeployAllocatorEVM.s.sol";
import { DeployAllocatorFEVMContract } from "./DeployAllocatorFEVM.s.sol";

contract DeployScript is ScaffoldETHDeploy {
  function run() external {
    // DeployYourContract deployYourContract = new DeployYourContract();
    // deployYourContract.run();

    // deploy more contracts here

    // deploy allocator contract
    // DeployAllocatorEVMContract deployAllocator = new DeployAllocatorEVMContract();
    // deployAllocator.run();

    DeployAllocatorFEVMContract deployAllocatorFEVM = new DeployAllocatorFEVMContract();
    deployAllocatorFEVM.run();
  }
}
