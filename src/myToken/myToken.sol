// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract MyERC20 is ERC20{
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
    }
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}