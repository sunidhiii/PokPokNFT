// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const fs = require("fs");

async function main() {

  let name = 'Pokpok Genesis Flock'
  let symbol = 'POK'
  let uriBeforeReveal = 'https://firebasestorage.googleapis.com/v0/b/pokpok-genesis/o/reveal%2Fmetadata.json?alt=media'
  let hash1 = '0xa2a2e473785f034c8616a6dfbf02a10edd36e9f11c66af4dacb18150683b0d6d'                 // '0x07557485171dae64b1af2f42d5c1785a1e40d6f827181a164203b9c11f5415e0'
  let hash2 = '0x96f0d690731d6e6f1ba76d35815e5623319ce8062619f0480d4ead859e6680e1'                 // '0x1237fc438557cb2c8927e1dc7fbc79a4ca1f9acf367a7e6455dbc2ccc4476a68'
  let time =  1711720800

  // const Contract = await hre.ethers.getContractFactory("PokPokNFT");
  // const contract = await Contract.deploy(name,symbol,uriBeforeReveal,hash1,hash2,time);
  // const addr = await contract.address;

  // console.log(
  //   `contract deployment address`, addr
  // );
  
  await hre.run("verify:verify", {
    address: '0xCE9a5b9bcD53e484C9e7b7BcBFC212a11240E891',
    constructorArguments: [name,symbol,uriBeforeReveal,hash1,hash2,time]
  });

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});