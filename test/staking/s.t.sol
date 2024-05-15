// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/staking/s.sol";
import "../../new-project/src/new.sol";

contract StakingRewardsTest is Test {
    StakingRewards public sr;
    address user;
    RikisToken public st;
    RikisToken public rt;

    function setUp() public {
        st = new RikisToken();
        rt = new RikisToken();
        sr = new StakingRewards(address(st), address(rt));
        rt.mint(address(sr), 100000);
        st.mint(user, 100);
        user = vm.addr(4);
        console.log(address(sr).balance);
    }

    // function testStake()public {
    //     vm.startPrank(user);
    //     st.approve(address(sr), 10000);
    //     sr.stake(100);
    //     vm.warp(block.timestamp + 2 days);
    //     sr.getReward();
    //     uint256 balance = address(user).balance;

    //     uint256 scale = 10000;
    //     uint256 scaledMultiplier = 16;
    //     uint256 twoDays = (172800 * scaledMultiplier) / scale;

    //     assertEq(balance, twoDays, "wrong!!!" );
    //     vm.stopPrank();

    // }
}
