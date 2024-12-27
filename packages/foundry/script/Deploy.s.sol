//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./DeployHelpers.s.sol";
import { DeployYourContract } from "./DeployYourContract.s.sol";
import { DeployFunctionsContract } from "./DeployFunctions.s.sol";

contract DeployScript is ScaffoldETHDeploy {
  function run() external {
    DeployYourContract deployYourContract = new DeployYourContract();
    deployYourContract.run();

    // deploy more contracts here
    // DeployFunctionsContract deployMyContract = new DeployFunctionsContract();
    // deployMyContract.run();
  }
}
