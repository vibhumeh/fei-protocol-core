const Orchestrator = artifacts.require("Orchestrator");
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
  	var pcvOrchestrator, bondingCurveOrchestrator, incentiveOrchestrator, controllerOrchestrator, idoOrchestrator, genesisOrchestrator, governorOrchestrator, coreOrchestrator, routerOrchestrator, stakingOrchestrator;

	deployer.then(function() {
	  	return ControllerOrchestrator.deployed();
	}).then(function(instance) {
		controllerOrchestrator = instance;
	  	return BondingCurveOrchestrator.deployed();
	}).then(function(instance) {
	  	bondingCurveOrchestrator = instance;
	  	return GenesisOrchestrator.deployed();
	}).then(function(instance) {
		genesisOrchestrator = instance
	  	return GovernanceOrchestrator.deployed();
	}).then(function(instance) {
	  	governorOrchestrator = instance;
	  	return IDOOrchestrator.deployed();
	}).then(function(instance) {
		idoOrchestrator = instance;
	 	return IncentiveOrchestrator.deployed();
	}).then(function(instance) {
		incentiveOrchestrator = instance;
	 	return RouterOrchestrator.deployed();
	}).then(function(instance) {
		routerOrchestrator = instance;
	 	return PCVDepositOrchestrator.deployed();
	}).then(function(instance) {
		pcvOrchestrator = instance;
	 	return StakingOrchestrator.deployed();
	}).then(function(instance) {
		stakingOrchestrator = instance;
	 	return deployer.deploy(CoreOrchestrator, {gas: 8000000});
	}).then(function(instance) {
		coreOrchestrator = instance;
	 	return deployer.deploy(Orchestrator,
	 		pcvOrchestrator.address, 
	 		bondingCurveOrchestrator.address, 
	 		incentiveOrchestrator.address, 
	 		controllerOrchestrator.address, 
	 		idoOrchestrator.address, 
	 		genesisOrchestrator.address, 
	 		governorOrchestrator.address,
			routerOrchestrator.address,
			stakingOrchestrator.address, 
			coreOrchestrator.address,
	 		accounts[0],
	 		{gas: 8000000}
	 	);
	}).then(function(instance) {
		orchestrator = instance;
	 	return bondingCurveOrchestrator.transferOwnership(orchestrator.address);
	}).then(function(instance) {
	 	return incentiveOrchestrator.transferOwnership(orchestrator.address);
	}).then(function(instance) {
		return coreOrchestrator.transferOwnership(orchestrator.address);
   	}).then(function(instance) {
	 	return idoOrchestrator.transferOwnership(orchestrator.address);
	}).then(function(instance) {
	 	return genesisOrchestrator.transferOwnership(orchestrator.address);
	}).then(function(instance) {
	 	return governorOrchestrator.transferOwnership(orchestrator.address);
	}).then(function(instance) {
	 	return controllerOrchestrator.transferOwnership(orchestrator.address);
	}).then(function(instance) {
	 	return pcvOrchestrator.transferOwnership(orchestrator.address);
	}).then(function(instance) {
	 	return routerOrchestrator.transferOwnership(orchestrator.address);
	}).then(function(instance) {
		return stakingOrchestrator.transferOwnership(orchestrator.address);
   });
}