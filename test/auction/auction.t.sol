// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/auction/auction.sol";
import "../../new-project/src/new.sol";

contract AuctionTest is Test {
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

    function testProposal() public {
        vm.startPrank(user);
        token.mint(address(user), 100);
        token.approve(address(a), 80);
        a.Proposal(80);
        address w = a.winner();
        assertEq(w, user, "error! the user is not the winner");
        assertEq(
            token.balanceOf(address(user)),
            20,
            "error! the amount not match"
        );
        assertEq(
            a.bidders(user),
            80,
            "error! the amount in the auction not match"
        );
        token.approve(address(a), 20);
        a.Proposal(20);
        assertEq(w, user, "error! the user is not the winner");
        assertEq(
            token.balanceOf(address(user)),
            0,
            "error! the amount not match"
        );
        assertEq(
            a.bidders(user),
            100,
            "error! the amount in the auction not match"
        );
        vm.stopPrank();
    }

    function testCancelation() public {
        vm.startPrank(user);
        token.mint(address(user), 50);
        token.approve(address(a), 50);
        a.Proposal(50);
        vm.stopPrank();

        address currentUser = vm.addr(434);
        vm.startPrank(currentUser);
        token.mint(address(currentUser), 160);
        token.approve(address(a), 160);
        a.Proposal(160);
        vm.stopPrank();

        vm.startPrank(user);
        token.approve(user, 50);
        a.cancelation();
        vm.stopPrank();

        assertEq(token.balanceOf(address(user)), 50, "error not mach money");
        assertEq(token.balanceOf(address(a)), 160, "error not mach money");
    }

    function testWinnerCantCancel() public {
        vm.startPrank(user);
        token.mint(address(user), 120);
        token.approve(address(a), 120);
        a.Proposal(120);
        vm.expectRevert();
        a.cancelation();
        vm.stopPrank();
    }

    function testProposalOverTime() public {
        vm.startPrank(user);
        token.mint(address(user), 120);
        token.approve(address(a), 120);
        vm.warp(block.timestamp + 8 days);
        vm.expectRevert();
        a.Proposal(120);
        vm.stopPrank();
    }

    function testFinish() public {
        vm.startPrank(user);
        token.mint(address(user), 120);
        token.approve(address(a), 120);
        a.Proposal(120);
        vm.warp(block.timestamp + 8 days);
        // vm.expectRevert();
        // nft.approve(user, 5);
        a.cancelation();
        assertEq(nft.balanceOf(address(user)), 5, "errorrrrrrrrrrr");
        vm.stopPrank();
    }
}
