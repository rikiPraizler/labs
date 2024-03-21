// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/wallet/wallet.sol";


contract WalletTest is Test {
    Wallet public w;

    // Everything I need to start my test
    function setUp() public {
        w = new Wallet();
        console.log(address(this));
    }

    function testDeposit() public {

        address randAdress= vm.addr(1111);
        vm.startPrank(randAdress);
        uint amount = 50;
        vm.deal(randAdress, amount);
        uint256 balanceBefore = address(w).balance;
	    // Call the deposit function of the Wallet contract with 1 ether
        payable(address(w)).transfer(10);
	    uint256 balanceAfter = address(w).balance;
	    assertEq(balanceAfter - balanceBefore, 10, "expect increase of 10 ether");
        assertEq(address(randAdress).balance, 40, "abcde");
        vm.stopPrank();
        
    }

    function testWithdraw() public {

        address userAllow = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;
        vm.startPrank(userAllow);
        uint amount = 50;
        vm.deal(address(w), amount);
        uint256 balanceBefore = address(userAllow).balance;
        w.withdraw(5);
        uint256 balanceAfter = address(userAllow).balance;
        assertEq(balanceBefore+5, balanceAfter);

        vm.stopPrank();

    }
}
