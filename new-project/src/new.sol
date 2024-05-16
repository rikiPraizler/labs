// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
contract RikisToken is ERC20 {
    constructor() ERC20("MyToken", "RPS") {
        this;
    }
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(address to, uint256 amount) public {
        burn(to, amount);
    }
}
