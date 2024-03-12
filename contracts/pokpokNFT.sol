// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./Common/ERC2981.sol";

contract pokpok is
    ERC721Enumerable,
    ERC721Burnable,
    ERC721URIStorage,
    ERC721Pausable,
    ERC2981,
    Ownable
{
    uint256 private _tokenIdCounter;
    bytes32 public whitelistRoot;
    string private baseTokenURI;
    mapping(address => bool) private _whitelist;
    
    constructor(
        string memory name,
        string memory symbol,
        string memory _baseTokenURI,
        bytes32 root
    ) Ownable(msg.sender) ERC721(name, symbol) {
        baseTokenURI = _baseTokenURI;
        whitelistRoot = root;
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

    function setBaseURI(string memory _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function mint(
        string memory _tokenURI,
        uint96 _royaltyFee, 
        bytes32[] memory proof
    ) external virtual returns (uint256 _tokenId) {
        require(MerkleProof.verify(proof, whitelistRoot, bytes32(uint256(uint160(msg.sender)))), "Invalid proof");
        _tokenId = _tokenIdCounter;
        _mint(_msgSender(), _tokenId);
        _setTokenURI(_tokenId, _tokenURI);
        _setTokenRoyalty(_tokenId, _msgSender(), _royaltyFee);
        _tokenIdCounter += 1;
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