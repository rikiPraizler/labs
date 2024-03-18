// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;

///@title Wallet1

contract Wallet1 {
    address public owner;

    address public user1;
    address public user2;
    address public user3;

    constructor() {
        //The owner receive who created the contract
        owner = payable(msg.sender);
        user1 = 0x1234567890123456789012345678901234567890;
        user2 = 0x9876543210987654321098765432109876543210;
        user3 = 0x9876543210987654324554541312109876587570;
    }

    //Reserved function that transfer the funds
    receive() external payable {}

    //only the owner can make this withdraw function
    function withdraw(uint256 amount) external {
        require(
            msg.sender == user1 ||
                msg.sender == user2 ||
                msg.sender == user3 ||
                msg.sender == owner,
            "you can't do this action"
        );
        payable(msg.sender).transfer(amount);
    }

    //return the contact's balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function changeUser(address oldUser, address newUser) external {
        require(msg.sender == owner, "you can't do this action");
        if (user1 == oldUser) {
            user1 = newUser;
            return;
        }
        if (user2 == oldUser) {
            user2 = newUser;
            return;
        }
        if (user3 == oldUser) {
            user3 = newUser;
            return;
        }
    }
}
