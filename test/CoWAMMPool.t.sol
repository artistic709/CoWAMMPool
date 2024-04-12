pragma solidity 0.8.24;

// SPDX-License-Identifier: unlicensed

import "../src/CoWAMMPool.sol";
import "./TestUtils.sol";

contract ERC20Mock is ERC20 {
    constructor(string memory name, string memory symbol, uint8 decimals) ERC20(name, symbol, decimals) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract CoWAMMPoolTest is TestUtils {

    CoWAMMPool pool;
    address token0;
    address token1;
    address safe;

    function setUp() public {
        token0 = address(new ERC20Mock("Token0", "T0", 18));
        token1 = address(new ERC20Mock("Token1", "T1", 18));
        if(token0 > token1) (token0, token1) = (token1, token0);
        safe = _nameToAddr("Safe");
        pool = new CoWAMMPool("Test Pool", "TP", 18, token0, token1, safe);
        vm.startPrank(safe);
        ERC20(token0).approve(address(pool), type(uint256).max);
        ERC20(token1).approve(address(pool), type(uint256).max);
        vm.stopPrank();
        deal(token0, address(this), 1000e18);
        deal(token1, address(this), 1000e18);
        ERC20(token0).approve(address(pool), type(uint256).max);
        ERC20(token1).approve(address(pool), type(uint256).max);
    }

    function testAddLiquidity() public {
        pool.addLiquidity(100e18, 1e18, 0);
        assertEq(pool.balanceOf(address(this)), 10e18-1000);
        assertEq(pool.totalSupply(), 10e18);
        assertEq(ERC20(token0).balanceOf(address(safe)), 100e18);
        assertEq(ERC20(token1).balanceOf(address(safe)), 1e18);
    }

    function testAddLiquidityMultiple() public {
        // first depositor
        pool.addLiquidity(100e18, 100e18, 0);

        // emulate earn fee
        ERC20Mock(token0).mint(address(safe), 100e18);
        ERC20Mock(token1).mint(address(safe), 100e18);
        assertEq(ERC20(token0).balanceOf(address(safe)), 200e18);
        assertEq(ERC20(token1).balanceOf(address(safe)), 200e18);

        // second depositor
        address user = _nameToAddr("User");
        deal(token0, user, 1000e18);
        deal(token1, user, 1000e18);
        vm.startPrank(user);
        ERC20(token0).approve(address(pool), type(uint256).max);
        ERC20(token1).approve(address(pool), type(uint256).max);
        pool.addLiquidity(100e18, 100e18, 0);
        vm.stopPrank();
        assertEq(pool.balanceOf(user), 50e18); // 100e18 * 100e18 / 200e18
        assertEq(pool.totalSupply(), 150e18);
        assertEq(ERC20(token0).balanceOf(address(safe)), 300e18);
        assertEq(ERC20(token1).balanceOf(address(safe)), 300e18);
    }

    function testRemoveLiquidity() public {
        pool.addLiquidity(100e18, 100e18, 0);
        pool.removeLiquidity(50e18, 0, 0);
        assertEq(pool.balanceOf(address(this)), 50e18-1000);
        assertEq(pool.totalSupply(), 50e18);
        assertEq(ERC20(token0).balanceOf(address(safe)), 50e18);
        assertEq(ERC20(token1).balanceOf(address(safe)), 50e18);
        assertEq(ERC20(token0).balanceOf(address(this)), 950e18);
        assertEq(ERC20(token1).balanceOf(address(this)), 950e18);
    }
        
}