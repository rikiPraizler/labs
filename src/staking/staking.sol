// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../new-project/src/new.sol";

contract Staking {
    RikisToken public immutable stakingToken;
    address public owner;
    mapping(address => mapping(uint => uint)) public usersDeposit;
    mapping(address => uint) public numOfDeposit;

    uint public totalSupply;

    // constructor() {
    //     owner = msg.sender;
    //     stakingToken = IERC20(0x19ea2A91313291cD43800d1524B017f6CB871bc7);
    //     stakingToken.transfer(address(this), totalSupply);
    // }
    constructor(address _stakingToken,uint _totalSupply) {
        totalSupply = _totalSupply;
        owner = msg.sender;
        stakingToken = RikisToken(_stakingToken);
        stakingToken.transfer(address(this), _totalSupply);
    }

    modifier existAddress(address user) {
        require(user != address(0), "Address does not make sense");
        _;
    }

    function deposit(uint amount) external {
        require(amount > 0, "you must deposit an amount greater than 0");
        usersDeposit[msg.sender][block.timestamp] = amount;
        stakingToken.transfer(address(this), amount);
        numOfDeposit[msg.sender] += 1;
    }

    function withdraw(uint amount) external existAddress(msg.sender) {
        require(amount > 0, "The amount must be greater than 0");
        uint amounWithdraw = amount;
        for (uint i = 0; i < numOfDeposit[msg.sender] && amount != 0; i++) {
            uint time = usersDeposit[msg.sender][i];
            require(block.timestamp > time + 1 weeks, "Time has not passed");
            uint depositedAmount = usersDeposit[msg.sender][time];
            if (amount <= depositedAmount) {
                usersDeposit[msg.sender][time] -= amount;
                amount = 0;
            } else {
                usersDeposit[msg.sender][time] = 0;
                amount -= depositedAmount;
            }
        }
        require(amount == 0, "you cant withdraw this amount");
        uint depositSupply = stakingToken.balanceOf(address(this)) -
            totalSupply;
        uint usersreward = (((amounWithdraw / depositSupply) * 2) / 100) * totalSupply * 10 ** 18;
        stakingToken.transferFrom(
            address(this),
            msg.sender,
            amounWithdraw + usersreward
        );
        totalSupply -= usersreward;
    }

    function getBalance() external view returns (uint) {
        return stakingToken.balanceOf(address(this));
    }
}
