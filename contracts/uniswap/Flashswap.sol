// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IUniswapV2Pair.sol';
import './IUniswapV2Router02.sol';
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

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint value) external returns (bool);

    function withdraw(uint) external;

    function balanceOf(address) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);
}

contract Flashswap {

    address public owner;
    address private WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function flashswap(address _borrowToken, uint256 _borrowNum, address _pairAddress, address _router) external payable {
        address token0 = IUniswapV2Pair(_pairAddress).token0();
        console.log("token0", token0);
        address token1 = IUniswapV2Pair(_pairAddress).token1();
        console.log("token1", token1);

        IUniswapV2Pair(_pairAddress).swap(
            _borrowToken == token0 ? _borrowNum : 0,
            _borrowToken == token1 ? _borrowNum : 0,
            address(this), abi.encode(_router));
    }

    function flashswapCallback(address _sender, uint _amount0, uint _amount1, bytes calldata _data) internal {
        //assert(msg.sender == UniswapV2Library.pairFor(factory, token0, token1));
        (address router) = abi.decode(_data, (address));
        uint256 borrowAmount = _amount0 == 0 ? _amount1 : _amount0;

        IUniswapV2Pair iUniswapV2Pair = IUniswapV2Pair(msg.sender);
        address token0 = iUniswapV2Pair.token0();
        address token1 = iUniswapV2Pair.token1();
        address borrowToken = _amount0 == 0 ? token1 : token0;
        IERC20 token = IERC20(borrowToken);

        // ===== your business logic ======
        console.log(address(this).balance);
        IWETH(WBNB).deposit{value : 1 * 10 ** 18}();
        console.log("balance WBNB", IERC20(WBNB).balanceOf(address(this)));

        IWETH(WBNB).approve(router, type(uint256).max);
        address USDT = 0x55d398326f99059fF775485246999027B3197955;
        address[] memory path1 = new address[](2);
        path1[0] = WBNB;
        path1[1] = USDT;  // USDT
        uint256 USDTBalance = IUniswapV2Router02(router).swapExactTokensForTokens(IERC20(WBNB).balanceOf(address(this)), 0, path1, address(this), block.timestamp + 100)[1];
        console.log("USDT", USDTBalance);

        IERC20(USDT).approve(router, type(uint256).max);
        address[] memory path2 = new address[](2);
        path2[0] = USDT;
        path2[1] = borrowToken;
        uint256 BUSDBalance = IUniswapV2Router02(router).swapExactTokensForTokens(USDTBalance, 0, path2, address(this), block.timestamp + 100)[1];
        console.log("BUSD", BUSDBalance);
        // ======= end ======

        uint256 tokenBalance = token.balanceOf(address(this));
        // DAIReservePre - DAIWithdrawn + (DAIReturned * .997) >= DAIReservePre
        // (DAIReturned * .997) - DAIWithdrawn >= 0
        uint256 amountRequired = borrowAmount + borrowAmount / 997 * 3;
        console.log("amountRequired", amountRequired);
        require(tokenBalance >= amountRequired, "not enough balance");

        // send BUSD back
        token.transfer(msg.sender, amountRequired);
        console.log("profit", tokenBalance - amountRequired);
    }

    function uniswapV2Call(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        flashswapCallback(_sender, _amount0, _amount1, _data);
    }

    function pancakeCall(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        flashswapCallback(_sender, _amount0, _amount1, _data);
    }
}