// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/staking/staking.sol";

pragma solidity ^0.8.20;

contract StakingTest is Test {
    Staking public s;
    function setUp() public {
        s = new Staking();
    }
    function depositTest() public {
        address randAdress = vm.addr(1111);
        vm.startPrank(randAdress);
        uint amount = 50;
        vm.deal(randAdress, amount);
        uint256 balanceBefore = address(s).balance;
        uint numOfBefore = s.numOfDeposit(msg.sender);
        s.deposit(amount);
        payable(address(s)).transfer(10);
        uint256 balanceAfter = address(s).balance;
        uint numOfAfter = s.numOfDeposit(msg.sender);
        assertEq(
            balanceAfter - balanceBefore,
            50,
            "expect increase of 50 ether"
        );
        assertEq(address(randAdress).balance, 0, "abcde");
        assertEq(numOfAfter - numOfBefore, 1, "aaaaa");
        vm.stopPrank();
    }

    function withdrawTest() external {
        address randAdress = vm.addr(1111);
        vm.startPrank(randAdress);
        uint amount = 50;
        // vm.deal(address(s), amount);
        vm.deal(randAdress, amount);
        // s.deposit(amount);
        uint256 balanceBefore = address(randAdress).balance;

        s.withdraw(50);
        assertEq(s.amount, 0, "there us a problem");
        uint256 balanceAfter = address(randAdress).balance;
        assertEq(balanceBefore + 50, balanceAfter);

        vm.stopPrank();
    }
}
