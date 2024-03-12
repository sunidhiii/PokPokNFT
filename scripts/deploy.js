// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const fs = require("fs");
const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

async function main() {
  let _baseTokenURI = "https://ipfs.io/ipfs/"
  let name = "Pok-Pok-NFT"
  let symbol = "PKPK"
  let leaf = "0x676DAD03011593CCB9eD596e44E60eeDBa39E60a"

  const leaves = [leaf].map(keccak256).sort(Buffer.compare)
  const tree = new MerkleTree(leaves, keccak256, { sort: true })

  const root = tree.getRoot()
  console.log("root",root)

  // const NFT = await hre.ethers.getContractFactory("pokpok");
  // const nft = await NFT.deploy(name,symbol,_baseTokenURI);
  // await nft.deployed();

  // console.log(
  //   `NFT contract deployment address`, nft.address
  // );


  // const NFTdata = {
  //   address: nft.address,
  //   abi: JSON.parse(nft.interface.format('json'))
  // }

  // fs.writeFileSync('./NFTdata.json', JSON.stringify(NFTdata))

  // //Verify the smart contract using hardhat 
  // await hre.run("verify:verify", {
  //   address: "0x2Ba02737c223078B9CAC9affb76cf4F8D985faD6",
  // });

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});