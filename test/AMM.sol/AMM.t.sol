// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/AMM/AMM.sol";
import "@hack/myToken/myToken.sol";


contract AMMTest is Test {
    AMM public amm;
    MyERC20 public tokenA;
    MyERC20 public tokenB;

    function setUp() public {
        tokenA = new MyERC20("tokenA", "a");
        tokenB = new MyERC20("tokenB", "b");
        amm = new AMM(address(tokenA), address(tokenB), 100, 300);

    }

    function tradeAtoBTest() public {
        address user = vm.addr(333);
        vm.startPrank(user);
        tokenA.mint(address(user), 20);
        amm.approve(address(user), 20);
        amm.tradeAtoB(10);
        assertEq();
    }
}