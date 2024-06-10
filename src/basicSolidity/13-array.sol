//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Array {

    uint[] public arr;
    uint[] public arr2 = [1,2,3];
    uint[10] public myFixedSizeArr;

    function get(uint i) public view returns (uint) {
        return arr[i];
    }

    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function push(uint i) public {
        arr.push(i);
    }
    
    function pop() public {
        arr.pop();
    }

    function getLength() public view returns (uint) {
        return arr.length;
    }

    function remove(uint i) public {
        delete arr[i];
    }

    function examples() external {
        uint[] memory a = new uint[](5);
    }
}

contract ArrayRemoveByShifting{
    uint[] public arr;
    function remove(uint index) public {
        require(index < arr.length, "the index is out of the array");
        for (uint i = index; i < arr.length - 1; i ++) {
            arr[i] = arr[i+1];
        }
        arr.pop();
    }

    
}