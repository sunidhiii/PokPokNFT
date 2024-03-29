// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const fs = require("fs");

async function main() {
  let name = 'PokPok'
  let symbol = 'PkPknft'
  let hash1 = '0x07557485171dae64b1af2f42d5c1785a1e40d6f827181a164203b9c11f5415e0'
  let hash2 = '0x1237fc438557cb2c8927e1dc7fbc79a4ca1f9acf367a7e6455dbc2ccc4476a68'
  let BaseURI = 'https://ipfs.io/ipfs/QmXUUXRSAJeb4u8p4yKHmXN1iAKtAV7jwLHjw35TNm5jN7'
  let time = 1711094764
  const Contract = await hre.ethers.getContractFactory("PokPokNFT");
  const contract = await Contract.deploy(name,symbol,BaseURI,hash1,hash2,time);
  await contract.deployed();

  console.log(
    `contract deployment address`, contract.address
  );

  const Contractdata = {
    address: contract.address,
    abi: JSON.parse(contract.interface.format('json'))
  }

  // fs.writeFileSync('./contract.json', JSON.stringify(Contractdata))

  // Verify the smart contract using hardhat 
  await hre.run("verify:verify", {
    address: '0x57CbD9933BF1031ED6aCbFa9c5B6ed60C8B896C2',
    constructorArguments: [name,symbol,BaseURI,hash1,hash2,time]
  });

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});