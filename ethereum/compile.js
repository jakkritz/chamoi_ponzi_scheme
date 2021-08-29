const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

const buildPath = path.resolve(__dirname, 'build');

// remove build folder if exists
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol'); 
const campaignFactoryPath = path.resolve(__dirname, 'contracts', 'CampaignFactory.sol'); 


// read file
const campaignSource = fs.readFileSync(campaignPath, 'utf8');
const campaignFactorySource = fs.readFileSync(campaignFactoryPath, 'utf8');

const input = {
	language: 'Solidity',
	sources: {
		'Campaign.sol': {
			content: campaignSource
		},
		'CampaignFactory.sol': {
			content: campaignFactorySource
		}
	},
	settings: {
        outputSelection: {
            '*': {
                '*': ['*']
            }
        }
    }
}

const output = JSON.parse(solc.compile(JSON.stringify(input))).contracts;

// create build folder if not exists
fs.ensureDirSync(buildPath);

for (let contract in output) {
	fs.outputJsonSync(
		path.resolve(buildPath, contract + '.json'),
		output[contract]
	)
}