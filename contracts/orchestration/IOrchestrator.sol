pragma solidity ^0.6.6;

import "../core/ICore.sol";

interface IOrchestrator {
    function detonate() external;
}

interface ICoreOrchestrator is IOrchestrator {
    function init(
        address admin
    ) external returns (ICore core, address tribe, address fei, uint256 tribeSupply);
}

interface IPCVDepositOrchestrator is IOrchestrator {
    function init(
        address core,
        address pair,
        address router,
        address oraclePair,
        uint256 twapDuration,
        bool isPrice0
    ) external returns (address ethUniswapPCVDeposit, address uniswapOracle);
}

interface IBondingCurveOrchestrator is IOrchestrator {
    function init(
        address core,
        address uniswapOracle,
        address ethUniswapPCVDeposit,
        uint256 scale,
        uint256 thawingDuration,
        uint256 bondingCurveIncentiveDuration,
        uint256 bondingCurveIncentiveAmount
    ) external returns (address ethBondingCurve, address bondingCurveOracle);
}

interface IIncentiveOrchestrator is IOrchestrator {
    function init(
        address core,
        address bondingCurveOracle,
        address fei,
        address router,
        uint32 growthRate
    ) external returns (address uniswapIncentive);
}

interface IRouterOrchestrator is IOrchestrator {
    function init(
        address pair,
        address weth
    ) external returns (address ethRouter);
}

interface IControllerOrchestrator is IOrchestrator {
    function init(
        address core,
        address bondingCurveOracle,
        address ethUniswapPCVDeposit,
        address fei,
        address router,
        uint256 reweightIncentive,
        uint256 reweightMinDistanceBPs
    ) external returns (address ethUniswapPCVController);
}

interface IIDOOrchestrator is IOrchestrator {
    function init(
        address core,
        address admin,
        address tribe,
        address pair,
        address router,
        uint256 releaseWindowDuration    
    ) external returns (
        address ido, 
        address timelockedDelegator
    );

    function initTimelocks(
        address timelockedDelegator,
        address admin,
        address tribe,
        uint256 releaseWindowDuration,
        uint256 numberOfTimelocks
    ) external returns (
        address[] memory timelockedDelegators
    );
}

interface IGenesisOrchestrator is IOrchestrator {
    function init(
        address core,
        address ethBondingCurve,
        address ido,
        address oracle,
        uint256 genesisDuration,
        uint256 exhangeRateDiscount
    ) external returns (address genesisGroup);
}

interface IStakingOrchestrator is IOrchestrator {
    function init(
        address core,
        address tribeFeiPair,
        address tribe,
        uint stakingDuration,
        uint dripFrequency,
        uint incentiveAmount
    ) external returns (address stakingRewards, address distributor);
}

interface IGovernanceOrchestrator is IOrchestrator {
    function init(
        address tribe,
        uint256 timelockDelay
    ) external returns (address governorAlpha, address timelock);
}
