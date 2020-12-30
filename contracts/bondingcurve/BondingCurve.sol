pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./IBondingCurve.sol";
import "./AllocationRule.sol";
import "../refs/OracleRef.sol";
import "../utils/Roots.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract BondingCurve is IBondingCurve, OracleRef, AllocationRule {
    using Decimal for Decimal.D256;
    using Roots for uint256;

	uint256 public override scale;
	uint256 public override totalPurchased; // FEI_b for this curve
	uint256 public override buffer = 100;
	uint256 public constant BUFFER_GRANULARITY = 10_000;

    event ScaleUpdate(uint _scale);
    event BufferUpdate(uint _buffer);
    event Purchase(address indexed _to, uint _amountIn, uint _amountOut);

	constructor(
		uint256 _scale, 
		address core, 
		address[] memory allocations, 
		uint256[] memory ratios, 
		address _oracle
	) public
		OracleRef(core, _oracle)
		AllocationRule(allocations, ratios)
	{
		_setScale(_scale);
	}

	function setScale(uint256 _scale) public override onlyGovernor {
		_setScale(_scale);
		emit ScaleUpdate(_scale);
	}

	function setBuffer(uint256 _buffer) public override onlyGovernor {
		require(_buffer < BUFFER_GRANULARITY, "BondingCurve: Buffer exceeds or matches granularity");
		buffer = _buffer;
		emit BufferUpdate(_buffer);
	}

	function setAllocation(address[] memory allocations, uint256[] memory ratios) public override onlyGovernor {
		_setAllocation(allocations, ratios);
	}

	function atScale() public override view returns (bool) {
		return totalPurchased >= scale;
	}

	function getCurrentPrice() public view override returns(Decimal.D256 memory) {
		if (atScale()) {
			return peg().mul(getBuffer());
		}
		return peg().div(getBondingCurvePriceMultiplier());
	}

	function getAmountOut(uint256 amountIn) public view override returns (uint256 amountOut) {
		uint256 adjustedAmount = getAdjustedAmount(amountIn);
		if (atScale()) {
			return getBufferAdjustedAmount(adjustedAmount);
		}
		return getBondingCurveAmountOut(adjustedAmount);
	}

	function getAveragePrice(uint256 amountIn) public view override returns (Decimal.D256 memory) {
		uint256 adjustedAmount = getAdjustedAmount(amountIn);
		uint256 amountOut = getAmountOut(amountIn);
		return Decimal.ratio(adjustedAmount, amountOut);
	}

	function getAdjustedAmount(uint256 amountIn) internal view returns (uint256) {
		return peg().mul(amountIn).asUint256();
	}

	function _purchase(uint256 amountIn, address to) internal returns (uint256 amountOut) {
	 	updateOracle();
	 	amountOut = getAmountOut(amountIn);
	 	incrementTotalPurchased(amountOut);
		fei().mint(to, amountOut);
		allocate(amountIn);
		emit Purchase(to, amountIn, amountOut);
		return amountOut;
	}

	function incrementTotalPurchased(uint256 amount) internal {
		totalPurchased += amount;
	}

	function _setScale(uint256 _scale) internal {
		scale = _scale;
	}

	function getBondingCurvePriceMultiplier() internal view virtual returns(Decimal.D256 memory);

	function getBondingCurveAmountOut(uint256 adjustedAmountIn) internal view virtual returns(uint256);

	function getBuffer() internal view returns(Decimal.D256 memory) {
		uint granularity = BUFFER_GRANULARITY;
		return Decimal.ratio(granularity - buffer, granularity);
	} 

	function getBufferAdjustedAmount(uint256 amountIn) internal view returns(uint256) {
		return getBuffer().mul(amountIn).asUint256();
	}
}