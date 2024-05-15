// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Wallet {
    address payable public owner;
    mapping(address => uint256) public gabaim;

    // Constructor: Initializes contract with owner and predefined addresses
    constructor() {
        owner = payable(msg.sender);
        // Predefined addresses that can withdraw
        gabaim[0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d] = 1;
        gabaim[0x7a3b914a1f0bD991BAf826F4fE9a47Bb9880d25f] = 1;
        gabaim[0x0638cF39b33D063c557AE2bC4B5D22a790Ac8Fe4] = 1;
    }

    // Fallback function: Allows the contract to receive Ether
    receive() external payable {}

    // Withdraw function: Allows owner and predefined addresses to withdraw Ether
    function withdraw(uint256 amount) external {
        require(
            owner == msg.sender || gabaim[msg.sender] == 1,
            "Only the owner and predefined addresses are allowed to withdraw Ether"
        );
        require(address(this).balance >= amount, "Insufficient balance");
        payable(msg.sender).transfer(amount);
    }

    function update(address oldGabai, address newGabai) public {
        require(owner == msg.sender, "Only the owner can update"); //only the owner can update gabaaim
        require(gabaim[oldGabai] == 1, "the old gabai is not exist"); // check if gabai exist in the hash
        require(gabaim[newGabai] == 0, "the gabai is exist"); // check if gabbai exist in the hash
        gabaim[newGabai] = 1;
        delete gabaim[oldGabai];
    }

    // Get Balance function: Returns the contract's balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
