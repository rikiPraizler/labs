// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/wallet/wallet.sol";

contract testFuzzWallet is Test {
    Wallet public w;

    function setUp() public {
        w = new Wallet();
        console.log(address(this));
    }

    function testFuzz_Deposit(uint256 amount) public {
        vm.assume(amount > 0 ether);
        address randAdress = vm.addr(1111);
        vm.startPrank(randAdress);
        vm.deal(randAdress, amount);
        uint256 balanceBefore = address(w).balance;
        // Call the deposit function of the Wallet contract with 1 ether
        payable(address(w)).transfer(amount);
        uint256 balanceAfter = address(w).balance;
        assertEq(balanceAfter - balanceBefore, amount, "aaa");
        assertEq(address(randAdress).balance, 0, "bbb");
        vm.stopPrank();
    }

    function testFuzz_Withdraw(uint256 amount) public {
        vm.assume(amount > 0 ether);
        address userAllow = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;

        vm.startPrank(userAllow);
        vm.deal(address(w), amount);
        uint256 balanceBefore = address(userAllow).balance;
        w.withdraw(amount);
        uint256 balanceAfter = address(userAllow).balance;
        assertEq(balanceBefore + amount, balanceAfter);

        vm.stopPrank();
    }
}
