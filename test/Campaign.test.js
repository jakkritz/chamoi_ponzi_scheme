const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider());


const compiledFactory = require('../ethereum/build/CampaignFactory.sol.json')
const compiledCampaign = require('../ethereum/build/Campaign.sol.json')

let accounts;
let factory;
let campaignAddress;
let campaign;

beforeEach(async () => {
	accounts = await web3.eth.getAccounts();

	// deploy contract
	factory = await new web3.eth.Contract(JSON.parse(compiledFactory).interface).deploy({
		data: compiledFactory.bytecode
	}).send({
		from: accounts[0],
		gas: '1000000',
	});

	// create campaign with minimum 100 wei
	await factory.methods.createCampaign('100').send({
		from: accounts[0],
		gas: '1000000'
	});

	// get deployed campaign addresses after created it
	const addresses = await factory.methods.getDeployedCampaign().call();
	campaignAddress = addresses[0];
	// equals to one-liner (destructuring array, take first element and assign it)
	// [campaignAddress] = await factory.methods.getDeployedCampaign().call();

	// get the contract (campaign) that is already deployed
	campaign = await new web3.eth.Contract(
		JSON.parse(compiledCampaign).interface,
		campaignAddress
	);
});

// test if campaign successfully deployed
describe('Campaigns', () => {
	it('deploys a factory and a campaign', () => {
		// assert.ok(factory.options.address);
		// assert.ok(campaign.options.address);
		asserts.ok(accounts);
	});
});