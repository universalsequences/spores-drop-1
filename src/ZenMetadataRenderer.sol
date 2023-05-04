// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import {IMetadataRenderer} from "zora-drops-contracts/interfaces/IMetadataRenderer.sol";
import './Base64.sol';
import './Conversion.sol';
import {MetadataRenderAdminCheck} from "zora-drops-contracts/metadata/MetadataRenderAdminCheck.sol";

contract ZenMetadataRenderer is IMetadataRenderer, MetadataRenderAdminCheck {

    constructor() {
    }

    struct MetadataURIInfo {
        string contractURI;
    }

    /// @notice NFT metadata by contract
    mapping(address => MetadataURIInfo) public metadataBaseByContract;

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        // token uri is simply a attributes
        return string(abi.encodePacked(
          'data:application/json;base64,',
          Base64.encode(bytes(
            abi.encodePacked(
              "{",
              "\"description\": \"Spores\", ",
              "\"image\": \"", imageURI(tokenId), "\", ", 
              "\"name\": \"Spores #", Conversion.uint2str(tokenId), "\", ", 
              generateAttributes(tokenId),
              "}"
          )))));
    }

    function imageURI(uint256 tokenId) internal view returns (string memory) {
        uint256 modded = tokenId % 5;
        return string(abi.encodePacked(
            "https://zequencer.mypinata.cloud/ipfs/QmcLbLqjVxTUXFVbrVeXJPKKdXGbdr1TNHEK3ahKHzzSoF/",
            Conversion.uint2str(modded)));
    }

    function generateAttributes(uint256 tokenId) internal view returns (string memory) {
        uint256 mod = tokenId % 5;
        string memory color = mod == 0 ? "purple" :
            mod == 1 ? "blue" :
            mod == 2 ? "green" :
            mod == 3 ? "yellow" :
            "pink";
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
        (string memory fuck, string memory initialContractURI) = abi
            .decode(data, (string, string));

        metadataBaseByContract[msg.sender] = MetadataURIInfo({
            contractURI: initialContractURI}
        );
        
    }

    function myContractURI() public returns (string memory) {
        return string(abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        string(
                            abi.encodePacked(
                                             '{"description": " Gives you access", "name": "Spores 1", "image": "https://zequencer.mypinata.cloud/ipfs/QmcLbLqjVxTUXFVbrVeXJPKKdXGbdr1TNHEK3ahKHzzSoF/1"}'))))));
    }


}
