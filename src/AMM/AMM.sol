// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AMM {

    uint public total;
    ERC20 public immutable tokenA ;
    ERC20 public immutable tokenB ;
    uint public balanceA;
    uint public balanceB;
    address public owner;
    constructor(address a ,address b ,uint countA,uint countB){
        owner = msg.sender;
        tokenA = ERC20(a);
        tokenB = ERC20(b);
        balanceA = countA;
        balanceB = countB;
        tokenA.transfer(address(this),balanceA);
        tokenB.transfer(address(this),balanceB);
        total = balanceA*balanceB;
    }

    function price() public view returns(uint){
        return total;
    }

    function tradeAtoB(uint amountA) external {
        require(amountA > 0, "the amount must be greater than 0");
        uint initialB = balanceB;
        balanceA += amountA;
        balanceB = price() / balanceA;
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(address(this), msg.sender, initialB - balanceB);
    }

    function tradeBtoA(uint amountB) external {
        require(amountB > 0, "the amount must be greater than 0");
        uint initialA = balanceA;
        balanceB += amountB;
        balanceA = price() / balanceB;
        tokenB.transferFrom(msg.sender, address(this), amountB);
        tokenA.transferFrom(address(this), msg.sender, initialA - balanceA);
    }

}