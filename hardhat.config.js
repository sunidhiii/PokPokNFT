require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { DEPLOYER_PRIVATE_KEY, TEST_USER_PRIVATE_KEY,  ALCHEMY_API_KEY} = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.21",

  networks: {
    base_sepolia: {
      url: ALCHEMY_API_KEY,
      accounts: [DEPLOYER_PRIVATE_KEY]
    }
    
  },
  etherscan: {
    apiKey: {
      base_sepolia: "G1KJFNVIRT835I8YU43HXSBWNBA4H7Z6KJ",
    }
  },
};