//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Array {
    uint256[] public arr;
    uint256[] public arr2 = [1, 2, 3];
    uint256[10] public myFixedSizeArr;

    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }

    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    function push(uint256 i) public {
        arr.push(i);
    }

    function pop() public {
        arr.pop();
    }

    function getLength() public view returns (uint256) {
        return arr.length;
    }

    function remove(uint256 i) public {
        delete arr[i];
    }

    function examples() external {
        uint256[] memory a = new uint256[](5);
    }
}

contract ArrayRemoveByShifting {
    uint256[] public arr;

    function remove(uint256 index) public {
        require(index < arr.length, "the index is out of the array");
        for (uint256 i = index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();
    }

    function test() external {
        arr = [2, 4, 6, 8, 10];
        remove(3);
        //now the arr : [2, 4, 6, 10]
        assert(arr[0] == 2);
        assert(arr[1] == 4);
        assert(arr[2] == 6);
        assert(arr[3] == 10);
        assert(arr.length == 4);

        arr = [7];
        remove(5);
        //now it will fail
        remove(0);
        assert(arr.length == 0);
    }
}

contract ArrayRemoveByCopyLastElement {
    uint256[] public arr;

    function remove(uint256 index) public {
        arr[index] = arr.length - 1;
        arr.pop();
    }

    function test() public {
        arr = [2, 4, 6, 8];
        remove(1);
        assert(arr[0] == 2);
        assert(arr[1] == 6);
        assert(arr[2] == 8);
        assert(arr.length == 3);
    }
}
