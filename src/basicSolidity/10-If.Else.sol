//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract IfElse {
    function foo(uint256 x) public pure returns (uint256) {
        if (x < 10) {
            return 0;
        } else if (x < 20) {
            return 1;
        } else {
            return 2;
        }
    }

    function ternary(uint256 y) public pure returns (uint256) {
        return y > 5 ? 1 : 2;
    }
}
