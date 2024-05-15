// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AMM {
    uint256 public total;
    ERC20 public immutable tokenA;
    ERC20 public immutable tokenB;
    uint256 public balanceA;
    uint256 public balanceB;
    address public owner;
    mapping(address => uint256) public depositors;

    constructor(address a, address b, uint256 countA, uint256 countB) {
        owner = msg.sender;
        tokenA = ERC20(a);
        tokenB = ERC20(b);
        balanceA = countA;
        balanceB = countB;
        tokenA.transfer(address(this), balanceA);
        tokenB.transfer(address(this), balanceB);
        total = balanceA * balanceB;
    }

    function price() public view returns (uint256) {
        return total;
    }

    function tradeAtoB(uint256 amountA) external {
        require(amountA > 0, "the amount must be greater than 0");
        uint256 initialB = balanceB;
        balanceA += amountA;
        balanceB = price() / balanceA;
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(address(this), msg.sender, initialB - balanceB);
    }

    function tradeBtoA(uint256 amountB) external {
        require(amountB > 0, "the amount must be greater than 0");
        uint256 initialA = balanceA;
        balanceB += amountB;
        balanceA = price() / balanceB;
        tokenB.transferFrom(msg.sender, address(this), amountB);
        tokenA.transferFrom(address(this), msg.sender, initialA - balanceA);
    }

    function addLiquidity(uint256 amount) external {
        require(amount > 0, "the amount must be greater than 0");
        uint256 calc = amount / (balanceA + balanceB);
        uint256 countA = calc * balanceA;
        uint256 countB = calc * balanceB;

        tokenA.transfer(address(this), countA);
        tokenB.transfer(address(this), countB);
        balanceA += countA;
        balanceB += countB;
        total = balanceA * balanceB;
        depositors[msg.sender] += amount;
    }

    function removeLiquidity(uint256 amount) external {
        require(amount > 0, "the amount must be greater than 0");
        require(depositors[msg.sender] >= amount, "you don't have enough tokens in the pool");
        uint256 calc = amount / (balanceA + balanceB);
        uint256 countA = calc * balanceA;
        uint256 countB = calc * balanceB;
        require(
            tokenA.balanceOf(msg.sender) >= countA && tokenB.balanceOf(msg.sender) >= countB,
            "you don't have enough tokens"
        );
        tokenA.transferFrom(address(this), msg.sender, countA);
        tokenB.transferFrom(address(this), msg.sender, countB);
        balanceA -= countA;
        balanceB -= countB;
        depositors[msg.sender] -= amount;
    }
}
