const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

async function main() {

  const whitelist = [
    "0x5c255d4eCe9bF502DAe41310407789ceA8aEF58a",
    "0x48C748BC5bcc05CED769706cD62f7FBB61fb9Ae3",
    "0x4aa12478e94909BE9b4C4c39e942DFB3AB505B95",
    "0xF88F6ee1bF60Ca54E3eAA9076E1ffe130B832dC7",
    "0xC2eE880819908FF1Ab33d1A8C9a3Eea001211A1F",
    "0x676DAD03011593CCB9eD596e44E60eeDBa39E60a",
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"
  ];

  const leaves = whitelist.map((addr) => keccak256(addr));
  const merkleTree = new MerkleTree(leaves, keccak256, { sortPairs: true });
  const rootHash = merkleTree.getRoot().toString("hex");
  console.log(`Whitelist Merkle Root: 0x${rootHash}`);
  
  whitelist.forEach((address) => {
    const proof = merkleTree.getHexProof(keccak256(address));
    console.log(`Adddress: ${address} Proof: ${proof}`);
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
