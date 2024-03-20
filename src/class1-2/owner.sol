// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/// @titel Owner

/// @dev Set & change owner

contract Owner {
    address private owner;

    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    //check if the caller function is the owner
    modifier isOwner() {
        require(msg.sender == owner, "caller is not owner");
        _;
    }

    //The function initializes the owner
    constructor() {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
    }

    //the function update the owner to the crurrent owner
    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    //The function returns the owner
    function getOwner() external view returns (address) {
        return owner;
    }
}
