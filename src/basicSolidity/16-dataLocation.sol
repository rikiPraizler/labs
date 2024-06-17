//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract DataLocation {
    uint256[] public arr;
    mapping(uint256 => address) public map;

    struct MyStruct {
        uint256 num;
    }

    mapping(uint256 => MyStruct) public myStructs;

    function f() public {
        _f(arr, map, myStructs[1]);

        myStruct storage myStruct = myStructs[1];
        myStruct memory myMemStruct = MyStruct(0);
    }

    function _f(uint256[] storage _arr, mapping(uint256[] => address) storage _map, MyStruct storage _myStruct)
        internal
    {
        //do something with storage variables
    }

    function g(uint256[] memory _arr) public returns (uint256[] memory) {
        //do something with memory array
    }

    function h(uint256[] calldata _arr) external {
        //do something with memory array
    }
}
