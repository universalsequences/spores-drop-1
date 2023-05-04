// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import "../src/ZenMetadataRenderer.sol";
import "../src/ZenDropCreator.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        address ZORA_DROPS_CREATOR = address(0xEf440fbD719cC5c3dDCD33b6f9986Ab3702E97A5);
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        ZenMetadataRenderer renderer = new ZenMetadataRenderer();
        ZenDropCreator creator = new ZenDropCreator(ZORA_DROPS_CREATOR);
        
        address drop = creator.newDrop(address(renderer));
        IERC721Drop(drop).purchase(100);
        
        vm.stopBroadcast();

    }
}
