// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/shareMoney/shareMoney.sol";

contract ShareMoneyTest is Test {
    ShareMoney public sh;

    function setUp() public {
        sh = new ShareMoney();
    }

    function testReceive() public {
        address randAddress = vm.addr(1111);
        vm.startPrank(randAddress);
        uint256 amount = 10000;
        vm.deal(randAddress, amount);
        uint256 balanceBefore = address(sh).balance;
        payable(address(sh)).transfer(10000);
        uint256 balanceAfter = address(sh).balance;
        assertEq(balanceAfter - balanceBefore, 10000, "it need be 10000");
        assertEq(address(randAddress).balance, 0, "the balanse need be 0");
        vm.stopPrank();
    }

    function testShare() external {
        payable(address(sh)).transfer(31);
        sh.share();
        uint256 s = sh.part();
        assertEq(s, 1, "it need be 1");
        uint256 user = address(sh.addressArray(10)).balance;
        assertEq(user, 1, "error!!!");
    }
}
