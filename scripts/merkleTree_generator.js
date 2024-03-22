const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");
const hre = require("hardhat");

async function main() {
  
  // let addresses = ["0xc225Dd56D374e44A65B0ad41933D9d6E3e09b77d","0x3aea99107030F24DfE7E298AaA3641646a80D2E8","0x227e73D5c6e5461485869D86Df2a39FaebBfEC4c","0xB68595Fce550B03b1A053FFDbdfD5A446823af37","0x5124C42C0123f33D7183b0FE8AA3f856C328efB5"]
  let addresses = ["0x5c255d4eCe9bF502DAe41310407789ceA8aEF58a","0x48C748BC5bcc05CED769706cD62f7FBB61fb9Ae3","0x4aa12478e94909BE9b4C4c39e942DFB3AB505B95","0xF88F6ee1bF60Ca54E3eAA9076E1ffe130B832dC7","0xC2eE880819908FF1Ab33d1A8C9a3Eea001211A1F"]
 
  const buf2hex = (x) => "0x" + x.toString("hex");
  const leaves = addresses.map((x) => keccak256(x)); //leaves
  const tree = new MerkleTree(leaves, keccak256, { sortPairs: true }); 
  const root = "0x" + tree.getRoot().toString("hex");
  const leaf = keccak256(addresses[3]).toString("hex"); 
  const proof = tree.getProof(leaf).map((x) => buf2hex(x.data));

  let merkTee =  keccak256("0x48C748BC5bcc05CED769706cD62f7FBB61fb9Ae3");
   
  console.log("proofsss",tree.getHexProof(merkTee))
  console.log(`Root - ${root}`); 
  console.log(`leaf - ${leaf}`);
  console.log(`proof - ${proof}`);


  

 
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});