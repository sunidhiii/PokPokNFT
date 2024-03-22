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
  let hash1 = '0xec7aee5bd301343474ef2b5bddaccc1e8e6fb50c66ac21aec2d49d630769c6a7'
  let hash2 = '0xb7ba564bbf04d23ade9695f583bd823a541084d23582ddadefcac25e834f78ac'
  let BaseURI = 'https://ipfs.io/ipfs/QmXUUXRSAJeb4u8p4yKHmXN1iAKtAV7jwLHjw35TNm5jN7'
  let time = 1711088620
  // const Contract = await hre.ethers.getContractFactory("pokpok");
  // const contract = await Contract.deploy(name,symbol,BaseURI,hash1,hash2,time);
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
  await hre.run("verify:verify", {
    address: '0x049e77cD29f82681A5aeF640cE41EDD7B504ca35',
    constructorArguments: [name,symbol,BaseURI,hash1,hash2,time]
  });

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});