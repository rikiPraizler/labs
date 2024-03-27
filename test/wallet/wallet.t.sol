// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/wallet/updateWallet.sol";

contract WalletTest is Test {
    Wallet public w;

    // Everything I need to start my test
    function setUp() public {
        w = new Wallet();
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

    function testWithdraw() public {
        address userAllow = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;
        vm.startPrank(userAllow);
        uint amount = 50;
        vm.deal(address(w), amount);
        uint256 balanceBefore = address(userAllow).balance;
        w.withdraw(5);
        uint256 balanceAfter = address(userAllow).balance;
        assertEq(balanceBefore + 5, balanceAfter);

        vm.stopPrank();
    }

    function testWithdrawNotAllow() public {
        address userNotAllow = 0x5ced660E3b925f034f99Df9466324F30A8Edf176;
        vm.startPrank(userNotAllow);
        uint amount = 50;
        vm.deal(address(w), amount);
        uint256 balanceBefore = address(userNotAllow).balance;
        vm.expectRevert();
        w.withdraw(5);
        uint256 balanceAfter = address(userNotAllow).balance;
        assertEq(balanceBefore, balanceAfter);

        vm.stopPrank();
    }

    function testUpdateAllowed() public {
        address owner = w.owner();
        vm.startPrank(owner);

        address oldGabai = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;
        address newGabai = 0x5ced660E3b925f034f99Df9466324F30A8Edf176;

        // Call the update function with the old and new Gabai addresses
        w.update(oldGabai, newGabai);

        // Assert that the values in the gabaim mapping are updated as expected
        assertEq(w.gabaim(newGabai), 1, "New Gabai not updated properly");
        assertEq(w.gabaim(oldGabai), 0, "Old Gabai not updated properly");

        vm.stopPrank();
    }

    function testUpdateNotAllowed() public {
        //not allowed address
        address add = 0xFc9ECA65d2BD19991F46ad73570920B2a7a23831;
        vm.startPrank(add);

        address oldGabai = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;
        address newGabai = 0x5ced660E3b925f034f99Df9466324F30A8Edf176;

        vm.expectRevert();
        // Call the update function with the old and new Gabai addresses
        w.update(oldGabai, newGabai);

        // Assert that the values in the gabaim mapping are updated as expected
        // assertEq(w.gabaim(newGabai), 1, "New Gabai not updated properly");
        // assertEq(w.gabaim(oldGabai), 0, "Old Gabai not updated properly");

        vm.stopPrank();
    }
    function testUpdateExistGabai() public {
        address owner = w.owner();
        vm.startPrank(owner);

        address oldGabai = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;
        address newGabai = 0x0638cF39b33D063c557AE2bC4B5D22a790Ac8Fe4;

        vm.expectRevert();
        // Call the update function with the old and new Gabai addresses
        w.update(oldGabai, newGabai);

        // Assert that the values in the gabaim mapping are updated as expected
        // assertEq(w.gabaim(newGabai), 1, "New Gabai not updated properly");
        // assertEq(w.gabaim(oldGabai), 0, "Old Gabai not updated properly");

        vm.stopPrank();
    }

    function testUpdateNotExistOldGabai() public {
        address owner = w.owner();
        vm.startPrank(owner);

        address oldGabai = 0xFc9ECA65d2BD19991F46ad73570920B2a7a23831;
        address newGabai = 0x0638cF39b33D063c557AE2bC4B5D22a790Ac8Fe4;

        vm.expectRevert();
        // Call the update function with the old and new Gabai addresses
        w.update(oldGabai, newGabai);

        // Assert that the values in the gabaim mapping are updated as expected
        // assertEq(w.gabaim(newGabai), 1, "New Gabai not updated properly");
        // assertEq(w.gabaim(oldGabai), 0, "Old Gabai not updated properly");

        vm.stopPrank();
    }

    function testGetBalance() public {
        assertEq(address(w).balance,w.getBalance());
    }
}
