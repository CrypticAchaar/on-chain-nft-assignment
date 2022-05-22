// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract DappCampNFT is ERC721Enumerable, Ownable {
    uint256 public MAX_MINTABLE_TOKENS = 5;

    constructor() ERC721("Nikhil's DappCamp NFT", "NRCAMP") Ownable() {}

    string[] private collection = [
        "blue", "orange", "white", "green", "purple"
    ];

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
        string memory output = sourceArray[rand % sourceArray.length];
        return output;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string memory svgImage = string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 100 100"><rect width="100" height="100" fill="', 
                pluck(tokenId, "NikhilRamesh", collection), 
                '" /></svg>'
            )
        );
        string memory imageField = string(
            abi.encodePacked(
                'data:image/svg+xml;base64,',
                Base64.encode(bytes(svgImage))
            )
        );

        string memory jsonData = string(
            abi.encodePacked(
                '{"name": "Color #',
                Strings.toString(tokenId),
                '", "description": "Bring colors to life.", "image": "',
                imageField,
                '"}'
            )
        );

        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(bytes(jsonData))
            )
        );
    }

    function claim(uint256 tokenId) public {
        require(tokenId > 0 && tokenId < MAX_MINTABLE_TOKENS, "Token ID invalid");
        _safeMint(_msgSender(), tokenId);
    }
}