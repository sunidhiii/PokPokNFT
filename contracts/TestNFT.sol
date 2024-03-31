// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./Common/ERC2981.sol";

contract TestNFT is
    ERC721Enumerable,
    ERC721Burnable,
    ERC721URIStorage,
    ERC721Pausable,
    ERC2981,
    Ownable,
    ReentrancyGuard
{
    enum Phase { Phase1, Phase2, Open }

    uint256 public MAX_SUPPLY = 888;
    bytes32 public whitelistRootPhase1;
    bytes32 public whitelistRootPhase2;
    string private uriBeforeReveal;                                 
    string private baseTokenURI;                                    
    uint256 public phase1TimeStamp;
    uint256 public phaseDuration = 15 minutes;
    uint96 public rotaltyPercentage = 500;
    bool public revealed = false;
    uint256 public currentTokenId;

    event Claimed(address indexed claimer, uint256 indexed tokenId);

    constructor(
        string memory name,
        string memory symbol,
        string memory _uriBeforeReveal,    
        bytes32 _rootPhase1,
        bytes32 _rootPhase2,
        uint256 _phase1TimeStamp
    ) Ownable(msg.sender) ERC721(name, symbol) {
        require(_phase1TimeStamp > block.timestamp, "Phase1 timestamp should be in the future");
        require(_rootPhase1 != bytes32(0x0) && _rootPhase2 != bytes32(0x0), "Cannot set null for whitelist Root Phase1 and Phase2");

        uriBeforeReveal = _uriBeforeReveal;
        whitelistRootPhase1 = _rootPhase1;
        whitelistRootPhase2 = _rootPhase2;
        phase1TimeStamp = _phase1TimeStamp;
    }

    function baseURI() external view returns (string memory) {
        return _baseURI();
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        _requireOwned(tokenId);
        
        if(!revealed) {
            return uriBeforeReveal;
        }

        return super.tokenURI(tokenId);
    }

    function mint() external nonReentrant whenNotPaused returns (uint256) { 

        require(msg.sender.code.length == 0, "Contract caller not allowed");
        require(msg.sender == tx.origin, "Contract caller not allowed");

        uint256 _tokenId = currentTokenId;
        require(_tokenId < MAX_SUPPLY, "All tokens have been minted");
        
        _mint(msg.sender, _tokenId);
        _setTokenRoyalty(_tokenId, msg.sender, rotaltyPercentage);
        currentTokenId += 1;

        emit Claimed(msg.sender, _tokenId);
        return _tokenId;
    }

    function reveal(string memory _baseTokenURI) external onlyOwner {
        revealed = true;
        baseTokenURI = _baseTokenURI;
    }

    function setRotaltyPercentage(uint96 _newRoyaltyPercent) external onlyOwner {
        rotaltyPercentage = _newRoyaltyPercent;
    }

    function setURIBeforeReveal(string memory _uriBeforeReveal) external onlyOwner {
        uriBeforeReveal = _uriBeforeReveal;
    }

    function setBaseURI(string memory _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    /**
     * @dev To pause the mint
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev To unpause the mint
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    
}