// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Campaign {
	struct Request {
		string description;
		uint value;
		address recipient;
		bool complete;
		uint approvalCount;
		mapping(address => bool) approvals; // people who approve this request
	}

	uint numRequests;
	mapping(uint => Request) public requests;

	address public manager; // token address of campaign manager
	uint public minimumContribution;

	// address[] public approvers; --> Change to mapping type
	mapping(address => bool) public approvers;

	uint public approversCount;

	modifier restricted() {
		require(msg.sender == manager);
		_; // placehoder for whatever function virtually pasted here
	}

	constructor(uint minimum) {
		manager = msg.sender;
		minimumContribution = minimum;
	}

	function contribute() public payable { // payable makes this function able to receive money
		require(msg.value > minimumContribution); // msg.value = amount of wei

		// approvers.push(msg.sender); --> Refactor to mapping
		approvers[msg.sender] = true; // set key 'msg.sender' to true

		approversCount++;
	}

	/*
	DATA LOCATION
	Storage: Holds data between function calls --> Hard Disk : PASS BY REFERENCE
	Memory: Temporary place to store data --> RAM : PASS BY VALUE

	---------------
	- memory and storage specifies which data location the variable refers to.
	- storage cannot be newly created in a function. Any storage referenced variable in a function 
	  always refers a piece of data pre-allocated on the contract storage (state variable). 
	  Any mutation persists after function call.
	- memory can only be newly created in a function. 
	  It can either be newly instantiated complex types like array/struct (e.g. via new int[...]) 
	  or copied from a storage referenced variable.
	- As references are passed internally through function parameters, 
	  remember they default to memory and if the variable was on storage, 
	  it would create a copy and any modification would not persist.
	*/
	function createRequest(string memory description, uint value, address recipient) public restricted {
		Request storage req = requests[numRequests++];

		req.description = description;
		req.value = value;
		req.recipient = recipient;
		req.complete = false;
		req.approvalCount = 0;
	}

	function approveRequest(uint index) public payable {
		// store a variable
		Request storage request = requests[index];

		// Check if this person has contributed
		require(approvers[msg.sender]);
		// Check if this person already voted
		require(!request.approvals[msg.sender]);

		// Set this person to 'have voted the request
		request.approvals[msg.sender] = true;
		// Increase count
		request.approvalCount++;
	}

	function finalizeRequest(uint index) public payable restricted {
		// store a variable
		Request storage request = requests[index];

		// check majority vote
		require(request.approvalCount > (approversCount / 2));

		require(!request.complete);

		// transfer money
		address payable transferee = payable(address(request.recipient));
		transferee.transfer(request.value);

		request.complete = true;
	}

}