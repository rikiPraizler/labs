// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

// import "@hack/staking/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {

    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;
    address public owner;
    mapping (address => uint) public usersDeposit;
    mapping (address => uint) public depositTime;
      
    uint public totalSupply = 1000000;


    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }
    constructor(address _stakingToken, address _rewardToken) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardToken);
        stakingToken.transfer(address(this),totalSupply);

    }

    function deposit(uint amount) external {
        require(amount > 0 , "you must deposit an amount greater than 0" );
        usersDeposit[msg.sender] += amount;
        stakingToken.transfer(address(this), amount);
        depositTime[msg.sender] = block.timestamp;
    }

    function withdraw(uint amount) external {
        require(usersDeposit[msg.sender] >= amount , "you don't have this amount to withdraw");
        require(block.timestamp > depositTime[msg.sender] + 1 weeks , "You can't withdraw the money yet");
        uint balance = stakingToken.balanceOf(address(this)) - totalSupply;
        uint percent = amount * 100 / balance;
        stakingToken.transferFrom(address(this), msg.sender, totalSupply * percent / 100);
        usersDeposit[msg.sender] -= amount;
        totalSupply -=  totalSupply * percent / 100;

    }

    function getBalance() external view returns(uint){
        return stakingToken.balanceOf(address(this));
    }
}