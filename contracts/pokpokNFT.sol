// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./Common/ERC2981.sol";

contract PokPokNFT is
    ERC721Enumerable,
    ERC721Burnable,
    ERC721URIStorage,
    ERC721Pausable,
    ERC2981,
    Ownable
{
    uint256 public MAX_SUPPLY = 888;
    bytes32 public whitelistRootPhase1;
    bytes32 public whitelistRootPhase2;
    string private baseTokenURI;
    uint256 public phase1TimeStamp;
    uint256 public phaseDuration = 30 minutes;
    uint96 public rotaltyPercentage = 50;
    mapping(address => bool) public alreadyClaimed;

    event Claimed(address indexed claimer, uint256 indexed tokenId);

    constructor(
        string memory name,
        string memory symbol,
        string memory _baseTokenURI,
        bytes32 _rootPhase1,
        bytes32 _rootPhase2,
        uint256 _phase1TimeStamp
    ) Ownable(msg.sender) ERC721(name, symbol) {
        baseTokenURI = _baseTokenURI;
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
        return super.tokenURI(tokenId);
    }

    function mint(bytes32[] calldata proof) external virtual returns (uint256) {        
        require(
            alreadyClaimed[msg.sender] == false,
            "User has already claimed a token"
        );

        require(block.timestamp >= phase1TimeStamp, "Pre-Sale not started");
        bytes32 leaf =  keccak256(abi.encodePacked(msg.sender));
        
        if (block.timestamp > phase1TimeStamp && block.timestamp <= phase1TimeStamp + phaseDuration) {
            require(
                MerkleProof.verify(proof, whitelistRootPhase1, leaf),
                "Invalid proof or Phase1 expired");
        } 
        if (
            block.timestamp > phase1TimeStamp + phaseDuration &&
            block.timestamp <= phase1TimeStamp + phaseDuration * 2
        ) {
            require(
               MerkleProof.verify(proof, whitelistRootPhase2, leaf),
                "Invalid proof or Phase2 expired"
            );
        } 

        uint256 _tokenId = totalSupply();
        require(_tokenId < MAX_SUPPLY, "All tokens have been minted");

        alreadyClaimed[msg.sender] = true;
        
        _mint(msg.sender, _tokenId);
        _setTokenRoyalty(_tokenId, msg.sender, rotaltyPercentage);
        
        emit Claimed(msg.sender, _tokenId);
        return _tokenId;
    }

    function updatePhase1(uint256 _newPhase1TimeStamp) external onlyOwner {
        require(block.timestamp > _newPhase1TimeStamp, "New phase1 timestamp should be in the future");
        phase1TimeStamp = _newPhase1TimeStamp;
    }

    function updatePhaseDuration(uint256 _newPhaseDuration) external onlyOwner {
        phaseDuration = _newPhaseDuration;
    }

    function setRotaltyPercentage(uint96 _newRoyaltyPercent) external onlyOwner {
        rotaltyPercentage = _newRoyaltyPercent;
    }

    function setWhitelistRoot(bytes32 _rootPhase1, bytes32 _rootPhase2) external onlyOwner {
        whitelistRootPhase1 = _rootPhase1;
        whitelistRootPhase2 = _rootPhase2;
    }

    function setBaseURI(string memory _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
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

