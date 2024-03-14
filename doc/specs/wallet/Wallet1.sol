// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;

///@title Wallet1
///@dev

contract Wallet1 {
    address payable public owner;

    constructor() {
        //The owner receive who created the contract
        owner = payable (msg.sender);
    }
    //Reserved function that transfer the funds
    receive() external payable {}

    //only the owner can make this withdraw function
    function withdraw (uint amount) external {
        require(owner == msg.sender, "you are not the owner");
        payable (msg.sender).transfer(amount);
    }

    //return the contact's balance
    function getBalance() external view returns (uint){
        return address(this).balance;
    }
}
