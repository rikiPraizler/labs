// SPDX-License-Identifier: MIT
// https://medium.com/@marketing.blockchain/how-to-create-a-multisig-wallet-in-solidity-cfb759dbdb35
pragma solidity ^0.8.20;

import "../../new-project/src/new.sol";
import "../../new-project/src/NFT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Lending {
    IERC20 public daiToken;
    RikisToken public bondToken;
    address public owner;
    uint256 public rewardPerS;
    // uint public wad = 10 ** 18;
    uint256 public duration;
    mapping(address => uint256) public daiDepositer;
    mapping(address => uint256) public depositTime;
    mapping(address => uint256) public rewards;

    constructor(address bondT) {
        owner = msg.sender;
        daiToken = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        bondToken = RikisToken(bondT);
        rewardPerS = 0.00000006 * 1e18;
    }

    modifier updateReward(address user) {
        if (daiDepositer[user] > 0) {
            duration = block.timestamp - depositTime[user];
            rewards[user] += (duration * rewardPerS) / 1e18;
            depositTime[user] = block.timestamp;
        }
        _;
    }

    function depositDAI(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "you must deposit amount greater than 0");
        require(daiToken.balanceOf(msg.sender) >= amount);
        daiDepositer[msg.sender] += amount;
        daiToken.transferFrom(msg.sender, address(this), amount);
        bondToken.mint(msg.sender, amount);
    }

    function withdrawDAI(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "amount = 0");
        require(amount <= rewards[msg.sender] + daiDepositer[msg.sender]);
        daiToken.transferFrom(address(this), msg.sender, amount);
        if (rewards[msg.sender] < amount) {
            amount -= rewards[msg.sender];
            rewards[msg.sender] = 0;
            daiDepositer[msg.sender] -= amount;
            bondToken.burn(msg.sender, amount);
        } else {
            rewards[msg.sender] -= amount;
        }
    }

    function depositETH(uint256 amount) external {}

    function withdrawETH() external {}
}
