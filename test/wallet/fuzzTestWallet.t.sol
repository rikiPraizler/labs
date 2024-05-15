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

    function fuzzTestDeposit(uint256 amount) public {
        vm.assume(amount > 0 ether);
        address randAdress = vm.addr(1111);
        vm.startPrank(randAdress);
        vm.deal(randAdress, amount);
        uint256 balanceBefore = address(w).balance;
        payable(address(w)).transfer(amount);
        uint256 balanceAfter = address(w).balance;
        assertEq(balanceAfter - balanceBefore, amount, "aaa");
        assertEq(address(randAdress).balance, 0, "bbb");
        vm.stopPrank();
    }


    function testWithdraw() public {
        address userAllow = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;
        vm.startPrank(userAllow);
        uint256 amount = 50;
        vm.deal(address(w), amount);
        uint256 balanceBefore = address(userAllow).balance;
        w.withdraw(5);
        uint256 balanceAfter = address(userAllow).balance;
        assertEq(balanceBefore + 5, balanceAfter);

        vm.stopPrank();
    }
    function testFuzzWithdraw(uint256 amount) public {
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

    function testFuzzWithdrawNotAllow(address add) public {
        vm.startPrank(add);
        uint256 balanceBefore = address(add).balance;
        vm.expectRevert();
        w.withdraw(5);
        uint256 balanceAfter = address(add).balance;
        assertEq(balanceBefore, balanceAfter);
        vm.stopPrank();
    }

    // //one it's work one it's not work
    // function testFuzzUpdate(address add) public {
    //     address owner = w.owner();
    //     vm.startPrank(owner);

    //     address oldGabai = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;
    //     w.update(oldGabai, add);

    //     assertEq(w.gabaim(add), 1, "New Gabai not updated properly");
    //     assertEq(w.gabaim(oldGabai), 0, "Old Gabai not updated properly");
    //     vm.expectRevert();
    //     w.update(oldGabai, add);
    //     assertEq(w.gabaim(add), 1, "");
    //     assertEq(w.gabaim(oldGabai), 0, "Old Gabai is exist");

    //     vm.stopPrank();
    // }

    // function testFuzzUpdateNotOwner(address add) public {
    //     vm.startPrank(add);
    //     address oldGabai = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;
    //     address newGabai = 0x074AC318E0f004146dbf4D3CA59d00b96a100100;
    //     vm.expectRevert();
    //     w.update(oldGabai, newGabai);
    //     assertEq(w.gabaim(newGabai), 0, "only owner can update");
    //     assertEq(w.gabaim(oldGabai), 1, "only owner can update");
    //     vm.stopPrank();
    // }
}
