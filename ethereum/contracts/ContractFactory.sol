// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Campaign.sol";

contract CampaignFactory {
	address[] public deployedCampaign;

	function createCampaign(uint minimum) public {
		address newCampaign = address(new Campaign(minimum, msg.sender));
		deployedCampaign.push(newCampaign);
	}

	function getDeployedCampaign() public view returns (address[] memory) {
		return deployedCampaign;
	}
}