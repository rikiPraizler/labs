// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/staking/staking.sol";
import "../../new-project/src/new.sol";

contract StakingTest is Test {
    Staking public s;
    RikisToken public token;

    function setUp() public {
        token = new RikisToken();
        s = new Staking(address(token), 1000000);
    }

    // function testDeposit() public{
    //     uint initialBalance = s.getBalance();
    //     uint amount = 120;
    //     token.mint(address(this),amount);
    //     token.approve(address(s),amount);
    //     s.deposit(amount);
    //     assertEq(s.getBalance() - initialBalance, amount);

    // }

    // function testWithdraw() public{
    //     uint amount = 120;
    //     token.mint(address(this),amount);
    //     token.approve(address(s),amount);
    //     s.deposit(amount);
    //     vm.warp(block.timestamp + 8 days);
    //     s.withdraw(amount);
    //     assertEq(s.getBalance(),0,"rtet");
    // }

    // function testDeposit() public{
    //     uint initialBalance = s.getBalance();
    //     console.log(address(s).balance);
    //     console.log(address(s));
    //     console.log(address(this).balance);
    //     uint amount = 120;
    //     token.mint(address(this),amount);
    //     token.approve(address(s),amount);
    //     s.deposit(amount);
    //     console.log(s.getBalance());
    //     console.log(initialBalance);
    //     assertEq(s.getBalance() - initialBalance, amount);
    //     // s.usersDeposit
    // }

    // function testWithdraw() public{
    //     uint amount = 120;
    //     token.mint(address(this),amount);
    //     token.approve(address(s),amount);
    //     s.deposit(amount);
    //     vm.warp(block.timestamp + 7 days);
    //     uint initialBalance = s.getBalance();
    //     console.log(initialBalance);
    //     s.withdraw(amount);
    //     uint afterBalance = s.getBalance();
    //     console.log(afterBalance);
    //     assertEq(initialBalance - amount, afterBalance);
    // }
}
