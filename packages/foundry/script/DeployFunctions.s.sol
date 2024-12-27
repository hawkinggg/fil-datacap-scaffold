//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/Functions.sol";
import "./DeployHelpers.s.sol";

contract DeployFunctionsContract is ScaffoldETHDeploy {
  // use `deployer` from `ScaffoldETHDeploy`
  function run() external ScaffoldEthDeployerRunner {
    Functions yourContract = new Functions(deployer);
    console.logString(
      string.concat(
        "Functions deployed at: ", vm.toString(address(yourContract))
      )
    );
  }
}
