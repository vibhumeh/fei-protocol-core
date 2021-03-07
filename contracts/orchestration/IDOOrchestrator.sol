pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

import "../genesis/IDO.sol";
import "../dao/TimelockedDelegator.sol";
import "./IOrchestrator.sol";

contract IDOOrchestrator is IIDOOrchestrator, Ownable {
    using Clones for address;

    function init(
        address core,
        address admin,
        address tribe,
        address pair,
        address router,
        uint256 releaseWindowDuration
    )
        public
        override
        onlyOwner
        returns (
            address ido, 
            address timelockedDelegatorA,
            address timelockedDelegatorB,
            address timelockedDelegatorC,
            address timelockedDelegatorD,
            address timelockedDelegatorE,
            address timelockedDelegatorF,
            address timelockedDelegatorG,
            address timelockedDelegatorH,
            address timelockedDelegatorI
        )
    {
        ido = address(
            new IDO(core, admin, releaseWindowDuration, pair, router)
        );
        timelockedDelegatorA = address(
            new TimelockedDelegator(tribe, admin, releaseWindowDuration)
        );
        timelockedDelegatorB = timelockedDelegatorA.clone();
        timelockedDelegatorC = timelockedDelegatorA.clone();
        timelockedDelegatorD = timelockedDelegatorA.clone();
        timelockedDelegatorE = timelockedDelegatorA.clone();
        timelockedDelegatorF = timelockedDelegatorA.clone();
        timelockedDelegatorG = timelockedDelegatorA.clone();
        timelockedDelegatorH = timelockedDelegatorA.clone();
        timelockedDelegatorI = timelockedDelegatorA.clone();
    }

    function detonate() public override onlyOwner {
        selfdestruct(payable(owner()));
    }
}
