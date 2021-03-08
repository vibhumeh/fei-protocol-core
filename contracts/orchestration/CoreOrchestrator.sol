pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IOrchestrator.sol";
import "../core/Core.sol";

// solhint-disable-next-line max-states-count
contract CoreOrchestrator is ICoreOrchestrator, Ownable {

    Core public core;

    constructor() public {
        core = new Core();
    }

    function init(address admin) public override onlyOwner returns(
        ICore _core, 
        address tribe, 
        address fei, 
        uint256 tribeSupply
    ) {
        core.init();
        core.grantGuardian(admin);
        core.grantGovernor(msg.sender);
        core.revokeGovernor(address(this));
        
        tribe = address(core.tribe());
        fei = address(core.fei());
        tribeSupply = IERC20(tribe).totalSupply();

        _core = ICore(core);
    }

    function detonate() public override onlyOwner {
        selfdestruct(payable(owner()));
    }
}
