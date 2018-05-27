pragma solidity ^0.4.23;

import "./ERC721.sol";
import "./ERC721BasicToken.sol";


/**
 * @title Full ERC721 Token
 * This implementation includes all the required and some optional functionality of the ERC721 standard
 * Moreover, it includes approve all functionality using operator terminology
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract BorsettaTitle is ERC721, ERC721BasicToken {
  
  // Title struct
    struct DiamondTitle {
        uint256 id;
        string labName;
        string date; 
        uint8 weight; 
        uint8 quality; 
        uint8 color;
        bytes32[] discrepencyProofs;
        bytes32[] transportationProofs;
        bytes32[] vaultStorageProofs;
        bytes32 accessKey;
    }  
  
  // Array of all title objects
    DiamondTitle[] internal borsettaTitles;

  // Mapping of title id to index in borsettaTitles array
    mapping(uint256 => uint256) borsettaTitlesIndex;

  // Title name -- "Borsetta Diamond Title"
    string internal name_;

  // Title symbol -- "BDT"
    string internal symbol_;

  // Mapping from owner to list of owned title IDs
    mapping(address => uint256[]) internal ownedTokens;

  // Mapping from title ID to index of the owner titles list
    mapping(uint256 => uint256) internal ownedTokensIndex;

  // Array with all title ids, used for enumeration
    uint256[] internal allTokens;

  // Mapping from title id to position in the allTokens array
    mapping(uint256 => uint256) internal allTokensIndex;

  // Optional mapping for title URIs
    mapping(uint256 => string) internal tokenURIs;

  /**
   * @dev Constructor function
   * @dev Called once when contract is iniated
   * @dev Sets contract metadata
   */
    constructor(string _name, string _symbol) public {
        name_ = _name;
        symbol_ = _symbol;
    }

  /**
   * @dev Gets the title name
   * @return string representing the title name
   */
    function name() public view returns (string) {
        return name_;
    }

  /**
   * @dev Gets the title symbol
   * @return string representing the title symbol
   */
    function symbol() public view returns (string) {
        return symbol_;
    }

  /**
   * @dev Returns an URI for a given title ID
   * @dev Throws if the title ID does not exist. May return an empty string.
   * @param _tokenId uint256 ID of the title to query
   */
    function tokenURI(uint256 _tokenId) public view returns (string) {
        require(exists(_tokenId));
        return tokenURIs[_tokenId];
    }

  /**
   * @dev Gets the token ID at a given index of the tokens list of the requested owner
   * @param _owner address owning the tokens list to be accessed
   * @param _index uint256 representing the index to be accessed of the requested tokens list
   * @return uint256 token ID at the given index of the tokens list owned by the requested address
   */
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256){
        require(_index < balanceOf(_owner));
        return ownedTokens[_owner][_index];
    }

  /**
   * @dev Gets the total amount of tokens stored by the contract
   * @return uint256 representing the total amount of tokens
   */
    function totalSupply() public view returns (uint256) {
        return allTokens.length;
    }

  /**
   * @dev Gets the token ID at a given index of all the tokens in this contract
   * @dev Reverts if the index is greater or equal to the total number of tokens
   * @param _index uint256 representing the index to be accessed of the tokens list
   * @return uint256 token ID at the given index of the tokens list
   */
    function tokenByIndex(uint256 _index) public view returns (uint256) {
        require(_index < totalSupply());
        return allTokens[_index];
    }

  /**
   * @dev Internal function to set the token URI for a given token
   * @dev Reverts if the token ID does not exist
   * @param _tokenId uint256 ID of the token to set its URI
   * @param _uri string URI to assign
   */
    function _setTokenURI(uint256 _tokenId, string _uri) internal {
        require(exists(_tokenId));
        tokenURIs[_tokenId] = _uri;
    }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * @param _to address representing the new owner of the given token ID
   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
   */
    function addTokenTo(address _to, uint256 _tokenId) internal {
        super.addTokenTo(_to, _tokenId);
        uint256 length = ownedTokens[_to].length;
        ownedTokens[_to].push(_tokenId);
        ownedTokensIndex[_tokenId] = length;
    }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * @param _from address representing the previous owner of the given token ID
   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
   */
    function removeTokenFrom(address _from, uint256 _tokenId) internal {
        super.removeTokenFrom(_from, _tokenId);

        uint256 tokenIndex = ownedTokensIndex[_tokenId];
        uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
        uint256 lastToken = ownedTokens[_from][lastTokenIndex];

        ownedTokens[_from][tokenIndex] = lastToken;
        ownedTokens[_from][lastTokenIndex] = 0;
    // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
    // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
    // the lastToken to the first position, and then dropping the element placed in the last position of the list

        ownedTokens[_from].length--;
        ownedTokensIndex[_tokenId] = 0;
        ownedTokensIndex[lastToken] = tokenIndex;
    }

  /**
   * @dev Internal function to mint a new token
   * @dev Reverts if the given token ID already exists
   * @dev called by front end at same time as _setDL(), _setWQC(), and _setAccessKey()
   * @param _to address the beneficiary that will own the minted token
   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
   * @param _date string date of diamond cultivation
   * @param _labName string name of diamond cultivation organization
   */
    function _mint(address _to, uint256 _tokenId, string _date, string _labName) internal {
        super._mint(_to, _tokenId);

        uint length = borsettaTitles.length;

        borsettaTitles[length].id = _tokenId;

        borsettaTitlesIndex[_tokenId] = length;

        allTokensIndex[_tokenId] = allTokens.length;
        allTokens.push(_tokenId);

        addTokenTo(_to, _tokenId);
    }

  /**
  * @dev Internal function to assign title cultivation date and lab (manufacturer) name 
  * @dev Reverts if title id is invalid -- feature to be added
  * @dev called by front end at same time as _mint()
  * @param _tokenId uint256 ID of the token to be minted by the msg.sender  
  * @param _date string represeting date of diamnond cultivation
  * @param _labName string  representing lab (manufacturer) name
  */
    function _setDL(uint256 _tokenId, string _date, string _labName) internal {
        uint length = borsettaTitles.length;

        borsettaTitles[length].date = _date; 
        borsettaTitles[length].labName = _labName;

        borsettaTitlesIndex[_tokenId] = length;
    }

  /**
  * @dev Internal function to assign title weight, quality, and color variables
  * @dev Reverts if title id is invalid -- feature to be added
  * @dev called by front end at same time as _mint()
  * @param _tokenId uint256 ID of the token to be minted by the msg.sender  
  * @param _weight uint8 represeting diamond weight
  * @param _quality uint8 representing diamond quality value
  * @param _color string representing diamond color 
  */
    function _setTitleWQC(uint256 _tokenId, uint8 _weight, uint8 _quality, uint8 _color) internal {
        uint256 index = borsettaTitlesIndex[_tokenId];
        borsettaTitles[index].weight = _weight;
        borsettaTitles[index].quality = _quality;
        borsettaTitles[index].color = _color;
    }

  /** 
  * @dev internal function to assign accessKey to title
  * @dev called by front end at same time as _mint()
  * @param _tokenId uint256 ID of working title
  * @param _accessKey bytes32 accessKey used to control supply chain stakeholder access
  */
    function _setAccessKey(uint256 _tokenId,  uint256 _accessKey) internal {
        uint256 index = borsettaTitlesIndex[_tokenId];
        borsettaTitles[index].accessKey = keccak256(_accessKey);
    }

  /**
   * @dev Internal function to burn a specific token
   * @dev Reverts if the token does not exist
   * @param _owner owner of the token to burn
   * @param _tokenId uint256 ID of the token being burned by the msg.sender
   */
    function _burn(address _owner, uint256 _tokenId) internal {
        super._burn(_owner, _tokenId);
  
    // Clear metadata (if any)
        if (bytes(tokenURIs[_tokenId]).length != 0) {
            delete tokenURIs[_tokenId];
        }

    // Reorg all tokens array
        uint256 tokenIndex = allTokensIndex[_tokenId];
        uint256 lastTokenIndex = allTokens.length.sub(1);
        uint256 lastToken = allTokens[lastTokenIndex];

        allTokens[tokenIndex] = lastToken;
        allTokens[lastTokenIndex] = 0;

        allTokens.length--;
        allTokensIndex[_tokenId] = 0;
        allTokensIndex[lastToken] = tokenIndex;
    }

}
