const CoreOrchestrator = artifacts.require("CoreOrchestrator");
const BondingCurveOrchestrator = artifacts.require("BondingCurveOrchestrator");
const IncentiveOrchestrator = artifacts.require("IncentiveOrchestrator");
const ControllerOrchestrator = artifacts.require("ControllerOrchestrator");
const IDOOrchestrator = artifacts.require("IDOOrchestrator");
const GenesisOrchestrator = artifacts.require("GenesisOrchestrator");
const GovernanceOrchestrator = artifacts.require("GovernanceOrchestrator");
const PCVDepositOrchestrator = artifacts.require("PCVDepositOrchestrator");
const RouterOrchestrator = artifacts.require("RouterOrchestrator");
const StakingOrchestrator = artifacts.require("StakingOrchestrator");

module.exports = function(deployer, network, accounts) {
  	var pcvo, bc, incentive, controller, ido, genesis, gov, core, routerOrchestrator, stakingOrchestrator;

	deployer.then(function() {
	  	return ControllerOrchestrator.deployed();
	}).then(function(instance) {
		controller = instance;
	  	return BondingCurveOrchestrator.deployed();
	}).then(function(instance) {
	  	bc = instance;
	  	return GenesisOrchestrator.deployed();
	}).then(function(instance) {
		genesis = instance
	  	return GovernanceOrchestrator.deployed();
	}).then(function(instance) {
	  	gov = instance;
	  	return IDOOrchestrator.deployed();
	}).then(function(instance) {
		ido = instance;
	 	return deployer.deploy(IncentiveOrchestrator);
	}).then(function(instance) {
		incentive = instance;
	 	return RouterOrchestrator.deployed();
	}).then(function(instance) {
		routerOrchestrator = instance;
	 	return PCVDepositOrchestrator.deployed();
	}).then(function(instance) {
		pcvo = instance;
	 	return StakingOrchestrator.deployed();
	}).then(function(instance) {
		stakingOrchestrator = instance;
	 	return deployer.deploy(CoreOrchestrator,
	 		pcvo.address, 
	 		bc.address, 
	 		incentive.address, 
	 		controller.address, 
	 		ido.address, 
	 		genesis.address, 
	 		gov.address,
			routerOrchestrator.address,
			stakingOrchestrator.address, 
	 		accounts[0],
	 		{gas: 8000000}
	 	);
	}).then(function(instance) {
		core = instance;
	 	return bc.transferOwnership(core.address);
	}).then(function(instance) {
	 	return incentive.transferOwnership(core.address);
	}).then(function(instance) {
	 	return ido.transferOwnership(core.address);
	}).then(function(instance) {
	 	return genesis.transferOwnership(core.address);
	}).then(function(instance) {
	 	return gov.transferOwnership(core.address);
	}).then(function(instance) {
	 	return controller.transferOwnership(core.address);
	}).then(function(instance) {
	 	return pcvo.transferOwnership(core.address);
	}).then(function(instance) {
	 	return routerOrchestrator.transferOwnership(core.address);
	}).then(function(instance) {
		return stakingOrchestrator.transferOwnership(core.address);
   });
}