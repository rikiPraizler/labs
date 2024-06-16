//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";

contract ContractTest is Test {
    ArrayDeleteBug arrayDeletionBugContract;
    // FixedArrayDeletion fixedArrayDeletionContract;

    function setUp() public {
        arrayDeletionBugContract = new ArrayDeleteBug();
        // fixedArrayDeletionContract = new FixedArrayDeletion();
    }

    function testArrayDeletion() public {
        arrayDeletionBugContract.arr(1);
        arrayDeletionBugContract.deleteElement(1);
        arrayDeletionBugContract.arr(1);
        arrayDeletionBugContract.getLength();
    }

    // function testFixedArrayDeletion() public {
    //     fixedArrayDeletionContract.arr(1);
    //     fixedArrayDeletionContract.deleteElement(1);
    //     fixedArrayDeletionContract.arr(1);
    //     fixedArrayDeletionContract.getLength();
    // }

    receive() external payable {}
}

contract ArrayDeleteBug {
    uint256[] public arr = [1, 2, 3, 4, 5];

    function deleteElement(uint256 index) external {
        require(index < arr.length, " invalid index");
        delete arr[index];
    }

    function getLength() public view returns (uint256) {
        return arr.length;
    }
}

// contract FixedArrayDeletion {
//     uint256[] public arr = [1, 2, 3, 4, 5];

//     //option 1: by coping the last element to the index and delete the last element
//     function deleteElement(uint256 index) external {
//         require(index < arr.length, "invalid index");
//         arr[index] = arr[arr.length - 1];
//         arr.pop();
//     }

//     //option 2: by shifting the elements from right to left
//     function deleteElement(uint256 index) external {
//         require(index < arr.length, "invalid index");
//         for (uint256 i = index; i < arr.length - 1; i++) {
//             arr[i] = arr[i + 1];
//         }
//         arr.pop();
//     }

//     function getLength() public view returns (uint256) {
//         return arr.length;
//     }
// }
