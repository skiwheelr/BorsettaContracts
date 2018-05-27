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
        string color;
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
    mapping(address => uint256[]) internal ownedTitles;

  // Mapping from title ID to index of the owner titles list
    mapping(uint256 => uint256) internal ownedTitlesIndex;

  // Array with all title ids, used for enumeration
    uint256[] internal allTitles;

  // Mapping from title id to position in the allTitles array
    mapping(uint256 => uint256) internal allTitlesIndex;

  // Optional mapping for title URIs
    mapping(uint256 => string) internal titleURIs;

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
   * @param _titleId uint256 ID of the title to query
   */
    function titleURI(uint256 _titleId) public view returns (string) {
        require(exists(_titleId));
        return titleURIs[_titleId];
    }

  /**
   * @dev Gets the token ID at a given index of the tokens list of the requested owner
   * @param _owner address owning the tokens list to be accessed
   * @param _index uint256 representing the index to be accessed of the requested tokens list
   * @return uint256 token ID at the given index of the tokens list owned by the requested address
   */
    function titleOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256){
        require(_index < balanceOf(_owner));
        return ownedTitles[_owner][_index];
    }

  /**
   * @dev Gets the total amount of tokens stored by the contract
   * @return uint256 representing the total amount of tokens
   */
    function totalSupply() public view returns (uint256) {
        return allTitles.length;
    }

  /**
   * @dev Gets the token ID at a given index of all the tokens in this contract
   * @dev Reverts if the index is greater or equal to the total number of tokens
   * @param _index uint256 representing the index to be accessed of the tokens list
   * @return uint256 token ID at the given index of the tokens list
   */
    function titleByIndex(uint256 _index) public view returns (uint256) {
        require(_index < totalSupply());
        return allTitles[_index];
    }

  /**
   * @dev Internal function to set the token URI for a given token
   * @dev Reverts if the token ID does not exist
   * @param _titleId uint256 ID of the token to set its URI
   * @param _uri string URI to assign
   */
    function _setTitleURI(uint256 _titleId, string _uri) internal {
        require(exists(_titleId));
        titleURIs[_titleId] = _uri;
    }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * @param _to address representing the new owner of the given token ID
   * @param _titleId uint256 ID of the token to be added to the tokens list of the given address
   */
    function addTitleTo(address _to, uint256 _titleId) internal {
        super.addTokenTo(_to, _titleId);
        uint256 length = ownedTitles[_to].length;
        ownedTitles[_to].push(_titleId);
        ownedTitlesIndex[_titleId] = length;
    }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * @param _from address representing the previous owner of the given token ID
   * @param _titleId uint256 ID of the token to be removed from the tokens list of the given address
   */
    function removeTitleFrom(address _from, uint256 _titleId) internal {
        super.removeTokenFrom(_from, _titleId);

        uint256 titleIndex = ownedTitlesIndex[_titleId];
        uint256 lastTitleIndex = ownedTitles[_from].length.sub(1);
        uint256 lastTitle = ownedTitles[_from][lastTitleIndex];

        ownedTitles[_from][titleIndex] = lastTitle;
        ownedTitles[_from][lastTitleIndex] = 0;
    // Note that this will handle single-element arrays. In that case, both titleIndex and lastTitleIndex are going to
    // be zero. Then we can make sure that we will remove _titleId from the ownedTitles list since we are first swapping
    // the lastToken to the first position, and then dropping the element placed in the last position of the list

        ownedTitles[_from].length--;
        ownedTitlesIndex[_titleId] = 0;
        ownedTitlesIndex[lastTitle] = titleIndex;
    }

  /**
   * @dev Internal function to mint a new token
   * @dev Reverts if the given token ID already exists
   * @param _to address the beneficiary that will own the minted token
   * @param _titleId uint256 ID of the token to be minted by the msg.sender
   * @param _date string date of diamond cultivation
   * @param _labName string name of diamond cultivation organization
   */
    function _mint(address _to, uint256 _titleId, string _date, string _labName) internal {
        super._mint(_to, _titleId);

        uint length = borsettaTitles.length;
        borsettaTitles[length].id = _titleId;
        borsettaTitles[length].date = _date; 
        borsettaTitles[length].labName = _labName;
        borsettaTitlesIndex[_titleId] = length;

        allTitlesIndex[_titleId] = allTitles.length;
        allTitles.push(_titleId);
    }

  /**
  * @dev Internal function to assign title weight, quality, and color variables
  * @dev Reverts if title id is invalid -- feature to be added
  * @param _weight uint8 represeting diamond weight
  * @param _quality uint8 representing diamond quality value
  * @param _color string representing diamond color 
  */
    function _setTitleWQC(uint256 _titleId, uint8 _weight, uint8 _quality, string _color) internal {
        uint256 index = borsettaTitlesIndex[_titleId];
        borsettaTitles[index].weight = _weight;
        borsettaTitles[index].quality = _quality;
        borsettaTitles[index].color = _color;
    }

  /**
   * @dev Internal function to burn a specific token
   * @dev Reverts if the token does not exist
   * @param _owner owner of the token to burn
   * @param _titleId uint256 ID of the token being burned by the msg.sender
   */
    function _burn(address _owner, uint256 _titleId) internal {
        super._burn(_owner, _titleId);
  
    // Clear metadata (if any)
        if (bytes(titleURIs[_titleId]).length != 0) {
            delete titleURIs[_titleId];
        }

    // Reorg all tokens array
        uint256 titleIndex = allTitlesIndex[_titleId];
        uint256 lastTitleIndex = allTitles.length.sub(1);
        uint256 lastTitle = allTitles[lastTitleIndex];

        allTitles[titleIndex] = lastTitle;
        allTitles[lastTitleIndex] = 0;

        allTitles.length--;
        allTitlesIndex[_titleId] = 0;
        allTitlesIndex[lastTitle] = titleIndex;
    }

}
