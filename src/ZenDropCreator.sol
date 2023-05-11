// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10; 
import "./IZoraNFTCreator.sol";
import './Base64.sol';
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import {console} from "forge-std/console.sol";
import {ERC721Drop} from "zora-drops-contracts/ERC721Drop.sol";

contract ZenDropCreator {

    
    IZoraNFTCreator creator;
    IERC721Drop.SalesConfiguration salesConfig;
    address zporeMinterAddress;

    bytes32 public immutable DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");

    // creatorAddress is the address of the zora-deployed "drop creator" 
    constructor(address creatorAddress) {
        creator = IZoraNFTCreator(creatorAddress);

        salesConfig = IERC721Drop.SalesConfiguration({
            publicSalePrice: 0,
            maxSalePurchasePerAddress: 1000,
            publicSaleStart: 0,
            publicSaleEnd: 500000000000000,
            presaleStart: 0,
            presaleEnd: 0,
            presaleMerkleRoot: 0x0
            });
    }
    

    // A reusable function for creating new drops using Zoras Drop contracts
    // with the initial media set 

    function newDrop(
      address metadataRenderer
      ) public returns (address)
    {
        // need to register shit with ZporeMinter at "defaultAdmin"

        bytes memory metadataInitializer = abi.encode(
            string(abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        string(
                            abi.encodePacked(
                                             '{"description": "Gives you access to https://spores.vision", "name": "Spore 1", "image": "https://zequencer.mypinata.cloud/ipfs/QmcLbLqjVxTUXFVbrVeXJPKKdXGbdr1TNHEK3ahKHzzSoF/1"}')))))));

        // defaultAdmin will be the "ZporeMinter"
        address newDropAddress = creator.setupDropsContract(
          "Spore 1",
          "SPORE",
          address(this),
          1000000000000, // unlimited?
          500, // BPS (what should i do for 8%?)
          payable(address(this)),
          salesConfig,
          IMetadataRenderer(metadataRenderer),
          metadataInitializer
       );

        // return the new drop address so that Stems contract can tie the "song" to the
        // remixes address
        return newDropAddress;
    }

}
