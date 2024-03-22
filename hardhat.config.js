require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { DEPLOYER_PRIVATE_KEY, TEST_USER_PRIVATE_KEY,  ALCHEMY_API_KEY} = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.21",

  networks: {
    sepolia: {
      url: ALCHEMY_API_KEY,
      accounts: [DEPLOYER_PRIVATE_KEY]
    }
    
  },
  etherscan: {
    // apiKey: {
    //   base: "XW8FARI4JVCRE6MIFDJNCK66H8P4N75A8G",
    // },
    customChains: [
      {
        network: "base",
        chainId: 84532,
        urls: {
          apiURL: ALCHEMY_API_KEY,
          browserURL: "https://sepolia-explorer.base.org"
        }
      }
    ]
  },
};