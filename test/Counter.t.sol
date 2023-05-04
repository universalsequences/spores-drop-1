// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ZenMetadataRenderer.sol";
import {console} from "forge-std/console.sol";

contract CounterTest is Test {
    ZenMetadataRenderer public renderer;

    function setUp() public {
        renderer = new ZenMetadataRenderer();
    }

    function testIncrement() public {
        console.log(renderer.tokenURI(4));
    }

    function testSetNumber(uint256 x) public {
    }
}
