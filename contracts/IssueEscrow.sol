// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IssueEscrow {
  enum Status { Open, Closed, Canceled }
  struct Issue {
    uint cost;
    Status status;
    address assignee;
    address creator;
  }
  mapping(string => Issue) public issues;
  modifier checkCreator(address creator) {
    require(msg.sender == creator, "You are not creator");
    _;
  }

  event Log(
    string action,
    string _id,
    uint _timestamp
  );


  function openIssue(
    string memory id,
    address assignee
  ) external payable {
    Issue memory newIssue = Issue(msg.value, Status.Open, assignee, msg.sender);
    issues[id] = newIssue;
    emit Log("Open", id, block.timestamp);
  }

  function cancelIssue(string memory id) external checkCreator(issues[id].creator) {
    issues[id].status = Status.Canceled;
    payable(issues[id].creator).transfer(issues[id].cost);
    emit Log("Cancel", id, block.timestamp);
  }

  function closeIssue(string memory id) external checkCreator(issues[id].creator) {
    require(issues[id].status == Status.Open, "Issue is not open");
    issues[id].status = Status.Closed;
    payable(issues[id].assignee).transfer(issues[id].cost);
    emit Log("Close", id, block.timestamp);
  }
}