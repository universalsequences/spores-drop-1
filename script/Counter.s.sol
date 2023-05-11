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
        
        //address drop = address(0x2e1BB408a2D9c5adf40079F20c8Ea94704e432c0);
        address drop = creator.newDrop(address(renderer));
        //renderer.updateSeed(drop, 1000);
        //renderer.updateSeed(drop, 1234);
        IERC721Drop(drop).purchase(40);
        //IERC721Drop(drop).purchase(95);
        renderer.updateSeed(drop, 3000);
        IERC721Drop(drop).purchase(80);
        // renderer.updateSeed(drop, 4000);
        /*
        IERC721Drop(drop).purchase(50);
        renderer.updateSeed(drop, 5000);
        IERC721Drop(drop).purchase(90);
        */
        
        vm.stopBroadcast();

    }
}
