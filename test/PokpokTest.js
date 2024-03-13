const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');
require("@nomiclabs/hardhat-truffle5");
const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

describe("NFT Marketplace", function () {
    var pokpokinstance;
    it("MerkleProof generation", async function () {
      const [owner,user1,user2] =  await ethers.getSigners();
      let leaf =[owner.address]
      const leaves = [leaf].map(keccak256).sort(Buffer.compare);
      const tree = new MerkleTree(leaves, keccak256, { sort: true });
      const root = tree.getRoot().toString("hex");
      console.log("root", root);
      console.log(Date.now())

      // const tokenURIPrefix = "https://gateway.pinata.cloud/ipfs/";
      // const pokpok = await ethers.getContractFactory("pokpok");
      // pokpokinstance = await pokpok.deploy(nft721tokenName,nft721tokenSymbol,tokenURIPrefix);
      // await pokpokinstance.deployed();
    });
});