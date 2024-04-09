// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    IERC20 public immutable stakingToken;
    address public owner;
    mapping(address => mapping(uint => uint)) public usersDeposit;
    mapping(address => uint) public numOfDeposit;

    uint public totalSupply = 1000000;

    // modifier onlyOwner() {
    //     require(msg.sender == owner, "not authorized");
    //     _;
    // }
    constructor() {
        owner = msg.sender;
        // stakingToken = IERC20(_stakingToken);
        stakingToken = IERC20(0x19ea2A91313291cD43800d1524B017f6CB871bc7);
        stakingToken.transfer(address(this), totalSupply);
    }
    // constructor(address _stakingToken) {
    //     owner = msg.sender;
    //     stakingToken = IERC20(_stakingToken);
    //     // stakingToken = IERC20(0x19ea2A91313291cD43800d1524B017f6CB871bc7);
    //     stakingToken.transfer(address(this), totalSupply);
    // }
    modifier reward(address user) {
        require(user != address(0), "Address does not make sense");
        _;
    }
    //deposit all???
    function deposit(uint amount) external {
        require(amount > 0, "you must deposit an amount greater than 0");
        usersDeposit[msg.sender][block.timestamp] = amount;
        stakingToken.transfer(address(this), amount);
        numOfDeposit[msg.sender] += 1;
    }

    function withdraw(uint amount) external reward(msg.sender) {
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
        uint usersreward = (((amounWithdraw / depositSupply) * 2) / 100) *
            totalSupply;
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
