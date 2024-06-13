//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Enum {
    enum Animals {
        dock,
        cat,
        cow,
        sheep
    }

    Animals public animal;

    function get() public view returns (Animals) {
        return animal;
    }

    function set(Animals _animal) public {
        animal = _animal;
    }

    function setExactly() public {
        animal = Animals.sheep;
    }

    function reset() public {
        delete animal;
    }
}
