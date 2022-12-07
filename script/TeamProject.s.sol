// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "../src/TeamProject.sol";

contract TeamProjectScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TeamProject project = new TeamProject();
        console2.log("contract deployed to:", address(project));

        vm.stopBroadcast();
    }
}
