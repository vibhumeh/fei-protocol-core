pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

import "../genesis/IDO.sol";
import "../dao/TimelockedDelegator.sol";
import "./IOrchestrator.sol";

contract IDOOrchestrator is IIDOOrchestrator, Ownable {
    using Clones for address;

    address public timelockedDelegator;
    address[] public timelockedDelegators;

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
            address timelockedDelegator
        )
    {
        ido = address(
            new IDO(core, admin, releaseWindowDuration, pair, router)
        );

        timelockedDelegator = address(
            new TimelockedDelegator(tribe, admin, releaseWindowDuration)
        );
    }

    function initTimelocks(
        address timelockedDelegator,
        address admin,
        address tribe,
        uint256 releaseWindowDuration,
        uint256 numberOfTimelocks
    )
        public
        override
        onlyOwner
        returns (
            address[] memory timelockedDelegators
        )
    {
        timelockedDelegators = new address[](numberOfTimelocks);
        timelockedDelegators[0] = timelockedDelegator;

        for(uint i = 1; i < numberOfTimelocks; i++) { // skip the first
            address timelockedDelegatorClone = timelockedDelegator.clone();
            TimelockedDelegator(timelockedDelegatorClone).initTimelockedDelegator(tribe, admin, releaseWindowDuration);
            timelockedDelegators[i] = timelockedDelegatorClone;
        }
    }

    function detonate() public override onlyOwner {
        selfdestruct(payable(owner()));
    }
}
