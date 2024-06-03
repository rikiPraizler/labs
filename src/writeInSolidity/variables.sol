//SPDK-License-Identifier: MIT
pragma solidity 0.8.19;

contract Variables {
    //stored on the blockchain
    string public text = "Hello";
    uint256 public num = 123;

    function doSomething() public {
        //not stored on the blockchain
        uint256 i = 456;

        //global variables
        uint256 timestamp = block.timestamp;
        address sender = msg.sender;
    }
}