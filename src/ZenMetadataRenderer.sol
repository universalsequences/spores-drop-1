// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import {IMetadataRenderer} from "zora-drops-contracts/interfaces/IMetadataRenderer.sol";
import {console} from "forge-std/console.sol";
import './Base64.sol';
import './Conversion.sol';
import {MetadataRenderAdminCheck} from "zora-drops-contracts/metadata/MetadataRenderAdminCheck.sol";
import './ITotalSupply.sol';

contract ZenMetadataRenderer is IMetadataRenderer, MetadataRenderAdminCheck {

    struct SeedData {
        uint256 lastTokenId;
        uint256 seed;
    }
        
    string private BASE_IMAGE_URI = "https://zequencer.mypinata.cloud/ipfs/QmQtAxrqx4vAGnySSS9Vatdz5iKB7E7XJKr85ZaXHPU5f1/";
    mapping(address => SeedData[]) private seeds;
    
    // will be called daily by admin to add entropy to the system
    function updateSeed(address target, uint256 additionalEntropy) public 
    //    requireSenderAdmin(target)
    {
        uint256 total = ITotalSupply(target).totalSupply();
        uint256 lastTokenId = total == 0 ? 0 : total;
        uint256 newSeed = uint256(keccak256(
           abi.encodePacked(block.timestamp, block.difficulty, additionalEntropy)));
        seeds[target].push(SeedData(lastTokenId, newSeed));
    }

    constructor() {
    }

    struct MetadataURIInfo {
        string contractURI;
    }

    function getSeedForTokenId(address target, uint256 tokenId) public view returns (uint256) {
        for (uint256 i = 0; i < seeds[target].length; i++) {
            if (tokenId > seeds[target][i].lastTokenId && (i == seeds[target].length - 1 || seeds[target][i+1].lastTokenId == tokenId+1 || tokenId <= seeds[target][i+1].lastTokenId)) {
                console.log(Conversion.uint2str(i));
                return seeds[target][i].seed;
            }
        }
        return 0;
        //revert("Token ID not found");
    }

    function getRarity(address target, uint256 tokenId) public view returns (uint256) {
        uint256 seed = getSeedForTokenId(target, tokenId);
        uint256 pseudoRandomValue = uint256(keccak256(abi.encodePacked(tokenId, seed))) % 100;

        if (pseudoRandomValue < 64) {
            return 1; // Common ( red )
        } else if (pseudoRandomValue < 89) {
            return 2; // Uncommon ( blue )
        } else if (pseudoRandomValue < 99) {
            return 3; // Rare ( green )
        } else {
            return 4; // Ultra-rare ( chrome )
        }
    }

    /// @notice NFT metadata by contract
    mapping(address => MetadataURIInfo) public metadataBaseByContract;

    function rareTokenURI(uint256 tokenId, uint256 rarity) internal view returns (string memory) {
        return string(abi.encodePacked(
          'data:application/json;base64,',
          Base64.encode(bytes(
            abi.encodePacked(
              "{",
              "\"description\": \"Introducing Spore 1, the immersive remixer. This tokens gives access to futuristic remixing available at https://spores.vision\", ",
              "\"image\": \"", imageURI(rarity), "\", ", 
              "\"name\": \"Spores #", Conversion.uint2str(tokenId), "\", ", 
              generateAttributes(rarity),
              "}"
          )))));
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        // token uri is simply a attributes
        address target = msg.sender;
        uint256 rarity = getRarity(target, tokenId);
        return rareTokenURI(tokenId, rarity);
    }

    function imageURI(uint256 rarity) internal view returns (string memory) {
        return string(abi.encodePacked(
            BASE_IMAGE_URI,
            Conversion.uint2str(rarity)));
    }

    function generateAttributes(uint256 rarity) internal view returns (string memory) {
        string memory color = rarity == 1 ? "red" :
            rarity == 2 ? "blue" :
            rarity == 3 ? "green" :
            "chrome";
        return string(abi.encodePacked(
            "\"attributes\": [{\"trait_type\": \"color\", \"value\": \"", color, "\"}]"
            ));
    }

    function contractURI() external view returns (string memory) {
        string memory uri = metadataBaseByContract[msg.sender].contractURI;
        if (bytes(uri).length == 0) revert();
        return uri;
    }

    function initializeWithData(bytes memory data) external {
        // data format: string baseURI, string newContractURI
        (string memory initialContractURI) = abi
            .decode(data, (string));

        metadataBaseByContract[msg.sender] = MetadataURIInfo({
            contractURI: initialContractURI}
        );
        
    }
}
