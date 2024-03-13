// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const fs = require("fs");
const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

async function main() {
  let leaf = ["0x676DAD03011593CCB9eD596e44E60eeDBa39E60a","0xAcA0F2947e01139C7dfDBa7939ec3D85ce9accCe","0xc225Dd56D374e44A65B0ad41933D9d6E3e09b77d"];
  console.log(leaf)

  const leaves = [leaf].map(keccak256).sort(Buffer.compare);
  console.log(leaves)
  const tree = new MerkleTree(leaves, keccak256, { sort: true });

  const root = tree.getRoot().toString("hex");
  console.log("root", root);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
