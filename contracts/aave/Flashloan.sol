// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IPool.sol";
import "./FlashLoanSimpleReceiverBase.sol";

import "hardhat/console.sol";

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract Flashloan is FlashLoanSimpleReceiverBase {
    address private owner;

    constructor(IPoolAddressesProvider provider) FlashLoanSimpleReceiverBase(provider){
        owner = msg.sender;
    }

    function flashloan(address loanToken, uint256 loanAmount) external {
        console.log("token to loan: ", loanToken, " amount: ", loanAmount);
        IPool(address(POOL)).flashLoanSimple(
            address(this),
            loanToken,
            loanAmount,
            "0x",
            0
        );
    }

    function executeOperation(address asset, uint256 amount, uint256 premium, address, bytes memory) public override returns (bool) {
        require(amount <= IERC20(asset).balanceOf(address(this)), "Invalid balance for the contract");
        console.log("borrowed token:", asset, "amount:", amount);
        console.log("flashloan fee: ", premium);
        // your business logic


        // ======
        uint256 amountToReturn = amount + premium;
        console.log("amount to return: ", amountToReturn);
        uint256 assetBalance = IERC20(asset).balanceOf(address(this));
        console.log("asset balance:", assetBalance);
        require(assetBalance >= amountToReturn, "Not enough amount to return loan");

        approveToken(asset, address(POOL), amountToReturn);
        console.log("DONE");
        return true;
    }

    function approveToken(address token, address to, uint256 amountIn) internal {
        require(IERC20(token).approve(to, amountIn), "approve failed");
    }
}