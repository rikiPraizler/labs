// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {

    IERC20 public immutable stakingToken;
    address public owner;
    mapping (address => mapping (uint => uint)) public usersDeposit;
    mapping (address => uint) public numOfDeposit;

    // mapping (address => uint) public depositTime;
      
    uint public totalSupply = 1000000;


    // modifier onlyOwner() {
    //     require(msg.sender == owner, "not authorized");
    //     _;
    // }
    constructor(address _stakingToken) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        // stakingToken = IERC20(0x19ea2A91313291cD43800d1524B017f6CB871bc7);
        stakingToken.transfer(address(this),totalSupply);

    }
    modifier reward(address user){
       require(user!=address(0),"Address does not make sense");
       _;
    }
    
    function deposit(uint amount) external {
        require(amount > 0 , "you must deposit an amount greater than 0" );
        usersDeposit[msg.sender][block.timestamp] = amount;
        stakingToken.transfer(address(this), amount);
        numOfDeposit[msg.sender] += 1;
    }

    // function withdraw(uint amount) external {
    //     require(amount > 0 , "the amount must be greater than 0" );
    //     require(usersDeposit[msg.sender] != 0, "you didn't stake in this pool");

    //     for (uint i = 0; i < numOfDeposit[msg.sender]; i++) {
    //     uint time = usersDeposit[msg.sender][i];
    //     if (time != 0 && block.timestamp > time + 1 weeks) {
    //         uint depositedAmount = usersDeposit[msg.sender][time];
    //         if (amount <= depositedAmount) {
    //             deposit[msg.sender][time] -= amount;
    //             totalWithdrawn += amount;
    //             break; // Exit the loop if the full amount has been withdrawn
    //         } else {
    //             deposit[msg.sender][time] = 0;
    //             totalWithdrawn += depositedAmount;
    //             amount -= depositedAmount;
    //         }
    //     }
    // }
    function withdraw(uint amount)  external reward(msg.sender){
        require(amount>0,"The amount must be greater than 0");

        for (uint i = 0; i < numOfDeposit[msg.sender]&&amount!=0; i++) {
            uint time = usersDeposit[msg.sender][i];
            // Check if the timestamp is valid (not 0) and if it's been more than a week
            require(block.timestamp > time + 1 weeks,"Time has not passed");
            uint depositedAmount = usersDeposit[msg.sender][time];
            if (amount <= depositedAmount) {
                usersDeposit[msg.sender][time] -= amount;
               amount=0;
            } else {
                usersDeposit[msg.sender][time] = 0;
                amount -= depositedAmount;
            }
       }
        require(amount==0,"you cant withdraw this amount");
        uint balanceSupply=stakingToken.balanceOf(address(this))-totalSupply;
        uint percentage = (amount * 100) /  balanceSupply;
        stakingToken.transferFrom(address(this),msg.sender,(totalSupply * percentage)/100);
    }
        // require(usersDeposit[msg.sender] >= amount , "you don't have this amount to withdraw");
        // require(block.timestamp > depositTime[msg.sender] + 1 weeks , "You can't withdraw the money yet");
        // uint balance = stakingToken.balanceOf(address(this)) - totalSupply;
        // uint percent = amount * 100 / balance;
        // stakingToken.transferFrom(address(this), msg.sender, totalSupply * percent / 100);
        // usersDeposit[msg.sender] -= amount;
        // totalSupply -=  totalSupply * percent / 100;

    // }

    function getBalance() external view returns(uint){
        return stakingToken.balanceOf(address(this));
    }
}