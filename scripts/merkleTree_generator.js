const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

async function main() {
  const whitelist1 =  [
    "0xD11eAE9BeA67218b0CA4AbcC4B41b394923a199C",
    "0x6bd9FC7EA4c4e18f7AB7179F2BD3DfC7248bA467",
    "0xA42bf5d0a692529c5c89aa38a79FD6E9C043D3ec",
    "0x2909E4b72fEb296e05Bd683319Fe1339ad247b4A",
    "0x4f6a46B0587EEaa225D9be1c2783B1B95B6F58a4",
  ];
  const whitelist2 =  [
    "0x676DAD03011593CCB9eD596e44E60eeDBa39E60a",
    "0xb4737c03B64e044a5F3e84B9795C9c2Ec88CbEC8",
    "0x7c856949DE8B7cc2ac9B43FF5DD9b70af3e24B86",
    "0xCb239CfEFA88472D5bFD15CECAA0148A78749105",
    "0xb1f27De396951EE04d1d637ccdF03171B9011B49",
    "0x84609D7889D2D5f03C3b9c98dFA6fB1A870e8a7c",
    "0x4818f2838475BFB919BA229DaF3Fb4aa7A4D05F4",
    "0x676DAD03011593CCB9eD596e44E60eeDBa39E60a",
    "0xD4aa6C63c68f5D89A47339C2e27eb6Bd11Da99e6",
    "0x06e1B2E23Fb8621503F408528162F1c077D1977b",
  ];

  const leaves = whitelist2.map((addr) => keccak256(addr));
  const merkleTree = new MerkleTree(leaves, keccak256, { sortPairs: true });
  const rootHash = merkleTree.getRoot().toString("hex");
  console.log(`Whitelist Merkle Root: 0x${rootHash}`);
  whitelist2.forEach((address) => {
    const proof = merkleTree.getHexProof(keccak256(address));
    console.log(`Adddress: ${address} Proof: ${proof}`);
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
