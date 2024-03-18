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
  let hash = '0x3983846329ee5530fa629605af38fc55be04a87a25e078d01bdecce9296118a7'
  let BaseURI = 'https://ipfs.io/ipfs/QmQwa9yTQRCJ3TsU2qkZywwphAhDXWsaWN2j53daLs3S3p/'
  // const Contract = await hre.ethers.getContractFactory("pokpok");
  // const contract = await Contract.deploy(name,symbol,BaseURI,hash,hash,1710763988);
  // await contract.deployed();

  // console.log(
  //   `contract deployment address`, contract.address
  // );


  // const Contractdata = {
  //   address: contract.address,
  //   abi: JSON.parse(contract.interface.format('json'))
  // }

  // fs.writeFileSync('./contract.json', JSON.stringify(Contractdata))

  //Verify the smart contract using hardhat 
  // await hre.run("verify:verify", {
  //   address: '0x0ddd3a1547967d459029DaA565CA96E60f1Cf5B0',
  //   constructorArguments: [name,symbol,BaseURI,hash,hash,1710763988]
  // });

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});