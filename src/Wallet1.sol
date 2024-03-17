// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;

///@title Wallet1
///@dev

contract Wallet1 {
    address public owner;
    address[] public owners = [
        0x1234567890123456789012345678901234567890,
        0x9876543210987654321098765432109876543210,
        0x9876543210987654324554541312109876543210
    ];

    constructor() {
        //The owner receive who created the contract
        owner = payable(msg.sender);
    }

    //Reserved function that transfer the funds
    receive() external payable {}

    //only the owner can make this withdraw function
    function withdraw(uint256 amount) external {
        bool isOwner = false;
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == msg.sender) isOwner = true;
        }
        require(owner == msg.sender || isOwner, "you are not the owner");
        payable(msg.sender).transfer(amount);
    }

    //return the contact's balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
