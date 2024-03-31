require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { DEPLOYER_PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.21",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
  networks: {
    base: {
      url: "https://mainnet.base.org",                        // "https://base-sepolia-rpc.publicnode.com",
      accounts: [DEPLOYER_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: {
      base: "C3FHT2DZTU1TCKCU4CZEHFAFWQGSZ4GGA5",
    },
    customChains: [
      {
        network: "base",
        chainId: 8453,                                        // 84532
        urls: {
          apiURL: "https://api.basescan.org/api",             // "https://api-sepolia.basescan.org/api",
          browserURL: "https://basescan.org/"                 // "https://sepolia.basescan.org/"     
        }
      }
    ]
  },
};