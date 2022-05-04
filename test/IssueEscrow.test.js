const IssueEscrowContact = artifacts.require("IssueEscrow")
const { v4: uuidv4 } = require('uuid')
const BN = require('bn.js')


contract("IssueEscrow", async (accounts) => {
  const creator = accounts[0]
  const assignee = accounts[1]
  const cost = new BN(1000)
  const id = uuidv4()

  it("Should deployed", async () => {
    const contact = await IssueEscrowContact.deployed();
    console.log(contact.address)
  })

  it("Open Issue", async () => {
    const contact = await IssueEscrowContact.deployed()

    await contact.openIssue(id, assignee, {
      from: creator,
      value: cost
    })

    const issue = await contact.issues(id)

    assert.equal(issue.creator, creator)
    assert.equal(issue.assignee, assignee)
    assert.equal(issue.status.toString(), "0")

    assert.isOk(cost.eq(issue.cost))

  })

  it("Close Issue", async () => {
    const contact = await IssueEscrowContact.deployed();
    await contact.closeIssue(id, {
      from: creator
    })

    const issue = await contact.issues(id)
    assert.equal(issue.status.toString(), "1")
  })
})