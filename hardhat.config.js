require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");
require("solidity-coverage");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
    localhost: {
      url: "http://127.0.0.1:8545"
    },
  defaultNetwork: "basesepolia",
  networks: {
    hardhat: {
    },
    basesepolia: {
      url: process.env.RPC_PROVIDER,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  
  solidity: {
    version: "0.8.21",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
      evmVersion: "istanbul"
    }
  },
  mocha: {
    timeout: 40000
  },
  etherscan: {
    apiKey: {
      sepolia: "XW8FARI4JVCRE6MIFDJNCK66H8P4N75A8G",
    }
  },
};