// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/auction/auction.sol";
import "../../new-project/src/new.sol";

contract testFuzzAuction is Test {
    Auction public a;
    address user;
    RikisToken public token;
    NFTtoken public nft;

    function setUp() public {
        token = new RikisToken();
        nft = new NFTtoken();
        a = new Auction(10, address(token), address(nft));
        user = vm.addr(1212);
    }

    function testFuzzProposal(uint amount) public {
        vm.assume(amount > 0);
        vm.startPrank(user);
        token.mint(address(user), amount);
        token.approve(address(a), amount);
        a.Proposal(amount);
        address w = a.winner();
        assertEq(w, user, "error! the user is not the winner");
        assertEq(
            token.balanceOf(address(user)),
            0,
            "error! the amount not match"
        );
        assertEq(
            a.bidders(user),
            amount,
            "error! the amount in the auction not match"
        );
        token.mint(address(user), amount);
        token.approve(address(a), amount);
        a.Proposal(amount);
        assertEq(w, user, "error! the user is not the winner");
        assertEq(
            token.balanceOf(address(user)),
            0,
            "error! the amount not match"
        );
        assertEq(
            a.bidders(user),
            amount + amount,
            "error! the amount in the auction not match"
        );
        vm.stopPrank();
    }

}
