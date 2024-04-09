// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/staking/staking.sol";

contract stakingTest is Test {
    Staking public s;

    function setUp() public {
        s = new Staking();
        console.log(address(this));
    }

    function testDeposit() public {
        address randAdress = vm.addr(1111);
        vm.startPrank(randAdress);
        uint amount = 50;
        vm.deal(randAdress, amount);
        uint256 balanceBefore = address(w).balance;
        // Call the deposit function of the Wallet contract with 1 ether
        payable(address(w)).transfer(10);
        uint256 balanceAfter = address(w).balance;
        assertEq(
            balanceAfter - balanceBefore,
            10,
            "expect increase of 10 ether"
        );
        assertEq(address(randAdress).balance, 40, "abcde");
        vm.stopPrank();
    }
}
