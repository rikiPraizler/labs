// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/auction/auction.sol";
import "../../new-project/src/new.sol";


contract AuctionTest is Test{
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

    function testProposal() public{
        vm.startPrank(user);
        token.mint(address(user),100);
        token.approve(address(a),80);
        a.Proposal(80);                    
        address w = a.winner();
        assertEq(w, user, "error! the user is not the winner");
        assertEq(token.balanceOf(address(user)), 20, "error! the amount not match");
        assertEq(a.bidders(user),80,"error! the amount in the auction not match");
        token.approve(address(a),20);
        a.Proposal(20);
        assertEq(w, user, "error! the user is not the winner");
        assertEq(token.balanceOf(address(user)), 0, "error! the amount not match");
        assertEq(a.bidders(user),100,"error! the amount in the auction not match");
        vm.stopPrank();
    }

    // function testCancelation() public{
    //     vm.startPrank(user);
    //     token.mint(address(user),50);
    //     token.approve(address(a),50);

    //     a.Proposal(50);
    //     // a.cancelation();

    //     vm.stopPrank();
    //     address u = vm.addr(434);
    //     vm.startPrank(u);
    //     token.mint(address(u),160);
    //     token.approve(address(a),160);

    //     a.Proposal(160);
    //     // a.cancelation();

    //     vm.stopPrank();
    //     vm.startPrank(user);
    //     token.approve(address(a),50);
    //     // console.log(a.owner());
    //     a.cancelation();
    //     vm.stopPrank();

    // }
}