// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./ERC2981.sol";

contract pokpok is
    ERC721Enumerable,
    ERC721Burnable,
    ERC721URIStorage,
    ERC721Pausable,
    ERC2981,
    Ownable
{
    uint256 public MAX_SUPPLY = 888;
    uint256 private _tokenIdCounter;
    bytes32 public whitelistRoot1;
    bytes32 public whitelistRoot2;
    string private baseTokenURI;
    uint256 public phase1;
    uint256 public Duration = 30 minutes;
    
    event Claimed(address indexed claimer, uint256 indexed tokenId);
    
    constructor(
        string memory name,
        string memory symbol,
        string memory _baseTokenURI,
        bytes32 root1,
        bytes32 root2,
        uint256 _phase1, 
    ) Ownable(msg.sender) ERC721(name, symbol) {
        baseTokenURI = _baseTokenURI;
        whitelistRoot1 = root1;
        whitelistRoot2 = root2;
        phase1 = _phase1;
    }

   function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }
 
    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }


    function baseURI() external view returns (string memory) {
        return _baseURI();
    }
    
    function setWhitelistRoot(bytes32 root1,bytes32 root2) external onlyOwner {
        whitelistRoot1 = root1;
        whitelistRoot2 = root2;
    }

    function setBaseURI(string memory _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function mint(
        string memory _tokenURI,
        bytes32[] memory proof
    ) external virtual returns (uint256 _tokenId) {
        require(block.timestamp >= phase1 , "Invalid Pre-Sale time");
        block.timestamp > phase1 && block.timestamp <= phase1 + Duration 
        ?require(MerkleProof.verify(proof, whitelistRoot1, bytes32(uint256(uint160(msg.sender)))) , "Invalid proof or Phase1 Expired")
        :block.timestamp > phase1 + Duration && block.timestamp <= phase1 + Duration*2 
        ?require(MerkleProof.verify(proof, whitelistRoot2, bytes32(uint256(uint160(msg.sender)))), "Invalid proof or Phase2 Expired") 
        :require(MerkleProof.verify(proof, whitelistRoot2, bytes32(uint256(uint160(msg.sender)))), "Invalid proof") ;        
        require(totalSupply() < MAX_SUPPLY, "All tokens have been minted");
        _tokenId = _tokenIdCounter;
        _mint(_msgSender(), _tokenId);
        _setTokenURI(_tokenId, _tokenURI);
        _setTokenRoyalty(_tokenId, _msgSender(), 50);
        _tokenIdCounter += 1;
        emit Claimed(_msgSender(), _tokenId);
        return _tokenId;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage , ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}