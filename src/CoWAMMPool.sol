pragma solidity 0.8.24;

// SPDX-License-Identifier: AGPL-3.0-only

import "./TransferHelper.sol";
import "./SqrtMath.sol";
import "./ERC20.sol";


contract CoWAMMPool is ERC20 {
    using TransferHelper for address;
    using SqrtMath for *;

    address public token0;
    address public token1;
    address public safe;
    uint256 public kLast;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address _token0,
        address _token1,
        address _safe
    ) ERC20(_name, _symbol, _decimals) {
        require(_token0 < _token1, "INVALID_TOKENS");
        token0 = _token0;
        token1 = _token1;
        safe = _safe;
    }

    function sync() external returns (uint256) {
        require(msg.sender == safe, "FORBIDDEN");
        uint256 balance0 = ERC20(token0).balanceOf(safe);
        uint256 balance1 = ERC20(token1).balanceOf(safe);
        kLast = (balance0 * balance1).sqrt();
        return kLast;
    }

    function addLiquidity(uint256 amount0, uint256 amount1, uint256 minAmountLP) external returns (uint256 amountLP) {
        require(amount0 > 0 || amount1 > 0, "INVALID_AMOUNTS");

        uint256 totalSupplyStored = totalSupply;
        uint256 balance0 = ERC20(token0).balanceOf(safe);
        uint256 balance1 = ERC20(token1).balanceOf(safe);
        uint256 kBefore = (balance0 * balance1).sqrt();
        uint256 kAfter = ((balance0 + amount0) * (balance1 + amount1)).sqrt();

        require(kBefore >= kLast, "K");
        kLast = kAfter;

        if (totalSupplyStored == 0) {
            amountLP = kAfter - 1000;
            _mint(msg.sender, amountLP);
            _mint(address(0), 1000);
        } else {
            amountLP = (kAfter - kBefore) * totalSupplyStored / kBefore;
            require(amountLP >= minAmountLP, "SLIPPAGE");
            _mint(msg.sender, amountLP);
        }

        token0.safeTransferFrom(msg.sender, safe, amount0);
        token1.safeTransferFrom(msg.sender, safe, amount1);
    }

    function removeLiquidity(uint256 amountLP, uint256 minAmount0, uint256 minAmount1) external returns (uint256 amount0, uint256 amount1) {
        require(amountLP > 0, "INVALID_AMOUNT");

        uint256 totalSupplyStored = totalSupply;
        uint256 balance0 = ERC20(token0).balanceOf(safe);
        uint256 balance1 = ERC20(token1).balanceOf(safe);
        amount0 = amountLP * balance0 / totalSupplyStored;
        amount1 = amountLP * balance1 / totalSupplyStored;
        require(amount0 >= minAmount0 && amount1 >= minAmount1, "INSUFFICIENT_AMOUNTS");

        kLast = ((balance0 - amount0) * (balance1 - amount1)).sqrt();

        _burn(msg.sender, amountLP);
        token0.safeTransferFrom(safe, msg.sender, amount0);
        token1.safeTransferFrom(safe, msg.sender, amount1);
    }

}