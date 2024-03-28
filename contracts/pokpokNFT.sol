// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

/**
 * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
 *
 * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
 * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
 *
 * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
 * fee is specified in basis points by default.
 *
 * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
 * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
 * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
 *
 * _Available since v4.5._
 */
abstract contract ERC2981 is IERC2981, ERC165 {
    struct RoyaltyInfo {
        address receiver;
        uint96 royaltyFraction;
    }

    mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC2981).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @inheritdoc IERC2981
     */
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        public
        view
        virtual
        override
        returns (address, uint256)
    {
        RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];

        uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) /
            _feeDenominator();

        return (royalty.receiver, royaltyAmount);
    }

    /**
     * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
     * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
     * override.
     */
    function _feeDenominator() internal pure virtual returns (uint96) {
        return 10000;
    }

    /**
     * @dev Sets the royalty information for a specific token id, overriding the global default.
     *
     * Requirements:
     *
     * - `receiver` cannot be the zero address.
     * - `feeNumerator` cannot be greater than the fee denominator.
     */
    function _setTokenRoyalty(
        uint256 tokenId,
        address receiver,
        uint96 feeNumerator
    ) internal virtual {
        require(
            feeNumerator <= _feeDenominator(),
            "ERC2981: royalty fee will exceed salePrice"
        );
        require(receiver != address(0), "ERC2981: Invalid parameters");

        _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
    }

    /**
     * @dev Resets royalty information for the token id back to the global default.
     */
    function _resetTokenRoyalty(uint256 tokenId) internal virtual {
        delete _tokenRoyaltyInfo[tokenId];
    }
}

contract PokPokNFT is
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
    string private uriBeforeReveal;                                 // https://firebasestorage.googleapis.com/v0/b/pokpok-adb67.appspot.com/o/reveal%2Fmetadata.json?alt=media
    string private baseTokenURI;                                    
    uint256 public phase1TimeStamp;
    uint256 public phaseDuration = 15 minutes;
    uint96 public rotaltyPercentage = 500;
    bool public revealed = false;
    uint256 public currentTokenId;

    mapping(address => mapping(Phase => bool)) public alreadyClaimed;

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
        
        if(!revealed) {
            return uriBeforeReveal;
        }

        return super.tokenURI(tokenId);
    }

    function premint(address _to, uint _amount) external nonReentrant onlyOwner {
        require(_amount > 0, "Invalid amount");
        require(_amount + currentTokenId <= 88, "Premint limit reached");    
        require(_to != address(0), "Cannot mint to a zero address");
        
        for(uint i = 0; i < _amount; i++) {
            uint256 _tokenId = currentTokenId;
            _mint(_to, _tokenId);
            _setTokenRoyalty(_tokenId, _to, rotaltyPercentage);  
            currentTokenId += 1; 
        }
    }

    function mint(bytes32[] calldata proof) external nonReentrant whenNotPaused returns (uint256) { 

        require(msg.sender.code.length == 0, "Contract caller not allowed");
        require(msg.sender == tx.origin, "Contract caller not allowed");

        require(block.timestamp > phase1TimeStamp, "Pre-Sale not started");
        bytes32 leaf =  keccak256(abi.encodePacked(msg.sender));

        Phase currentPhase = Phase.Open;
        
        if (block.timestamp > phase1TimeStamp && block.timestamp <= phase1TimeStamp + phaseDuration) {
            currentPhase = Phase.Phase1;
            require(
                MerkleProof.verify(proof, whitelistRootPhase1, leaf),
                "Invalid proof for Phase1!"
            );
        } 
        if (
            block.timestamp > phase1TimeStamp + phaseDuration &&
            block.timestamp <= phase1TimeStamp + phaseDuration * 2
        ) {
            currentPhase = Phase.Phase2;
            require(
               MerkleProof.verify(proof, whitelistRootPhase2, leaf),
                "Invalid proof for Phase2!"
            );
        } 

        require(
            !alreadyClaimed[msg.sender][currentPhase],
            "User has already claimed a token"
        );

        uint256 _tokenId = currentTokenId;
        require(_tokenId < MAX_SUPPLY, "All tokens have been minted");

        alreadyClaimed[msg.sender][currentPhase] = true;
        
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

    function updatePhase1(uint256 _newPhase1TimeStamp) external onlyOwner {
        require(_newPhase1TimeStamp > block.timestamp, "New phase1 timestamp should be in the future");
        phase1TimeStamp = _newPhase1TimeStamp;
    }

    function updatePhaseDuration(uint256 _newPhaseDuration) external onlyOwner {
        require(_newPhaseDuration >= 900, "Minimum duration is 15 mins");
        phaseDuration = _newPhaseDuration;
    }

    function setRotaltyPercentage(uint96 _newRoyaltyPercent) external onlyOwner {
        rotaltyPercentage = _newRoyaltyPercent;
    }

    function setWhitelistRoot(bytes32 _rootPhase1, bytes32 _rootPhase2) external onlyOwner {
        require(_rootPhase1 != bytes32(0x0) && _rootPhase2 != bytes32(0x0), "Cannot set null for whitelist Root Phase1 and Phase 2");
        
        whitelistRootPhase1 = _rootPhase1;
        whitelistRootPhase2 = _rootPhase2;
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



