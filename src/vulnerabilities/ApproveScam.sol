//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";

contract ContractTest is Test {
    ERC20 ERC20Contract;
    address alice = vm.addr(1);
    address eve = vm.addr(2);

    function testApproveScam() public {
        ERC20Contract = new ERC20();
        ERC20Contract.mint(1000);
        ERC20Contract.transfer(address(alice), 1000);
        vm.prank(alice);
        ERC20Contract.approve(address(eve), type(uint256).max);

        console.log("Before exploiting, Balance of Eve:", ERC20Contract.balanceOf(eve));
        console.log("now eve can transfer more funds from alice");

        vm.prank(eve);
        ERC20Contract.transferFrom(address(alice), address(eve), 1000);
        console.log("eve transfer all the funds to her account", ERC20Contract.balanceOf(eve));
        console.log("the funds transferred");
    }

    receive() external payable {}
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function NalanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, address amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20 is IERC20 {
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name = "test example";
    string public symbol = "test";
    uint8 public decimals = 18;

    function transfer(address recipient, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer((msg.sender), recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint256 amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn (uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
