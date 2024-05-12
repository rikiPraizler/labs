// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTtoken is ERC721 {
    constructor() ERC721("NFTtoken", "NFT") {
        
    }
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}