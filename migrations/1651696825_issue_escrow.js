const IssueEscrowContact = artifacts.require("IssueEscrow")
module.exports = function(_deployer) {
  _deployer.deploy(IssueEscrowContact)
}
