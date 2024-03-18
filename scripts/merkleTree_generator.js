const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");
const hre = require("hardhat");

async function main() {
  let addresses = ["0xA56eA15Ce3527e2eCA8CF3ea0253e8f4faAadDB9","0xAcA0F2947e01139C7dfDBa7939ec3D85ce9accCe","0xc225Dd56D374e44A65B0ad41933D9d6E3e09b77d","0x3aea99107030F24DfE7E298AaA3641646a80D2E8","0x227e73D5c6e5461485869D86Df2a39FaebBfEC4c","0xB68595Fce550B03b1A053FFDbdfD5A446823af37"];
  // Hash addresses to get the leaves
  let leaves = addresses.map((addr) => keccak256(addr));
  // Create tree
  let merkleTree = new MerkleTree(leaves, keccak256, { sortPairs: true });
  // Get root
  let rootHash = merkleTree.getRoot().toString("hex");

  // Pretty-print tree
  console.log(`rootHash`,rootHash);
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});