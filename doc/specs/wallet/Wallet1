// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
contract Wallet2 {
    address payable public owner;
    constructor() {
        owner = payable(msg.sender);
    }
    receive() external payable {}
    function withdraw(uint wad) external {
        owner.transfer(wad);
    }
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
