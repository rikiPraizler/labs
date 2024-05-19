// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@hack/myCoin/MyERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract Lending{
    IERC20 public daiToken;

    MyERC20 public bondToken;

    address public owner;

    uint public rewardPerS;
    uint public totalRewards;
    uint public collateralRatio = 10 * 1e18 / 10;
    uint public percentFee = (3 * 9999997) * 1e18 / 1000;

    mapping (address => uint) public daiDeposits;
    mapping (address => uint) public depositsTime;
    mapping (address => uint) public rewards;
    mapping (address => uint) public ethDeposits;
    mapping (address => uint) public lendings;
    mapping (address => uint) public lendingTime;
    mapping (address => uint) public fees;


    constructor(address bond) {
        owner = msg.sender;
        daiToken = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        bondToken = MyERC20(bond);
        rewardPerS = 0.000000000002 * 1e18;
    }

    modifier updateReward(address user) {
        if(daiDeposits[user] > 0){
            uint duration = block.timestamp - depositsTime[user];
            rewards[user] += (duration * rewardPerS) / 1e18;
            depositsTime[user] = block.timestamp;
        }
        _;
    }

    modifier updateFee(address user){
        if(lendings[user] > 0){
            uint duration = block.timestamp - lendingTime[user];
            fees[user] += (duration * (percentFee * lendings[msg.sender])) / 1e18;
            lendingTime[user] = block.timestamp;
        }
        _; 
    }

    function depositDai(uint amount) external updateReward(msg.sender){
        require(amount != 0, "amount equals 0");
        require(daiToken.balanceOf(msg.sender) >= amount);
        daiDeposits[msg.sender] += amount;
        daiToken.transferFrom(msg.sender, address(this), amount);
        bondToken.mint(msg.sender, amount);
    }

    function withdrawDai(uint amount) external updateReward(msg.sender){
        require(amount != 0, "amount equals 0");
        require(amount <= (rewards[msg.sender] + daiDeposits[msg.sender]));
        daiToken.transferFrom(address(this), msg.sender, amount);
        if(rewards[msg.sender] < amount){
            amount -= rewards[msg.sender];
            rewards[msg.sender] = 0;
            daiDeposits[msg.sender] -= amount;
            bondToken.burn(msg.sender, amount);
        }
        else{
            rewards[msg.sender] -= amount;
        }
    }
    receive() external payable{
        ethDeposits[msg.sender] += msg.value;
    }
    
    function lending(uint amount) external updateFee(msg.sender){
        require(amount != 0, "amount equals 0");
        require((amount * collateralRatio) / getPrice(0x2a1530C4C41db0B0b2bB646CB5Eb1A67b7158667) <= ethDeposits[msg.sender]);
        require(amount <= daiToken.balanceOf(address(this)), "there isn't enough dai in the pool");
        daiToken.transferFrom(address(this), msg.sender, amount);
        lendings[msg.sender] += amount;
    }

    function loanRepayment(uint amount) external updateFee(msg.sender){
        require(amount != 0, "amount equals 0");
        require(amount == lendings[msg.sender] + fees[msg.sender], "your loan is greater");
        totalRewards += fees[msg.sender];
        fees[msg.sender] = 0;
        lendings[msg.sender] = 0;
        daiToken.transferFrom(msg.sender, address(this), amount);
    }
    function getPrice(address token) public returns (uint256 amount) {
        require(token == address(daiToken) || token == 0x2a1530C4C41db0B0b2bB646CB5Eb1A67b7158667, "invalid-token"); // DAI or ETH
        amount = token == address(daiToken) ? 3000 : 1;
    }
}