const Orchestrator = artifacts.require("Orchestrator");

module.exports = function(deployer) {
	deployer.then(function() {
	 	return Orchestrator.deployed();
	}).then(function(instance) {
		orchestrator = instance;
	 	return orchestrator.initCore();
	}).then(function() {
	 	return orchestrator.initPairs();
	}).then(function() {
	 	return orchestrator.initPCVDeposit();
	}).then(function() {
	 	return orchestrator.initBondingCurve();
	}).then(function() {
	 	return orchestrator.initIncentive();
	}).then(function() {
	 	return orchestrator.initController();
	}).then(function() {
		 return orchestrator.initIDO();
	}).then(function() {
	 	return orchestrator.initGovernance();
	}).then(function() {
	 	return orchestrator.initRouter();
	}).then(function() {
		return orchestrator.initGenesis();
	}).then(function() {
		return orchestrator.initStaking();
    });
}