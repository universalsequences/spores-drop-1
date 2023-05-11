// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ZenMetadataRenderer.sol";
import "../src/mock/MockDrop.sol";
import {console} from "forge-std/console.sol";

contract CounterTest is Test {
    ZenMetadataRenderer public renderer;
    MockDrop public drop;

    function setUp() public {
        renderer = new ZenMetadataRenderer();
        drop = new MockDrop(address(renderer));
    }

    function testUpdateSeed() public {
        drop.updateTotalSupply(1); // equivalent of minting tokenId=1
        renderer.updateSeed(address(drop), 1000); // afterwards we update seed

        uint256 seed1 = uint256(keccak256(
            abi.encodePacked(block.timestamp, block.difficulty, uint256(1000))));

        assertEq(renderer.getSeedForTokenId(address(drop), 2), seed1);

        drop.updateTotalSupply(2); // equiv of minting tokenId=2

        uint256 seed2 = uint256(keccak256(
            abi.encodePacked(block.timestamp, block.difficulty, uint256(2000))));
        renderer.updateSeed(address(drop), 2000);

        assertEq(renderer.getSeedForTokenId(address(drop), 3), seed2);

        // confirm that tokenId=2 still uses seed1 (immutable)
        assertEq(renderer.getSeedForTokenId(address(drop), 2), seed1);

        drop.updateTotalSupply(5); // equiv of minting tokenId=2
        uint256 seed3 = uint256(keccak256(
            abi.encodePacked(block.timestamp, block.difficulty, uint256(3000))));
        renderer.updateSeed(address(drop), 3000);

        // finally just run through tokens to ensure everything is correct
        assertEq(renderer.getSeedForTokenId(address(drop), 2), seed1);
        assertEq(renderer.getSeedForTokenId(address(drop), 3), seed2);
        assertEq(renderer.getSeedForTokenId(address(drop), 4), seed2);
        assertEq(renderer.getSeedForTokenId(address(drop), 5), seed2);
        assertEq(renderer.getSeedForTokenId(address(drop), 6), seed3);
 
    }

    function testIncrement() public {
        drop.updateTotalSupply(1); // equivalent of minting tokenId=1
        renderer.updateSeed(address(drop), 2000); // afterwards we update seed

        console.log(drop.tokenURI(3));
        console.log(drop.tokenURI(4));
        console.log(drop.tokenURI(8));
        console.log(drop.tokenURI(18));
    }
}
