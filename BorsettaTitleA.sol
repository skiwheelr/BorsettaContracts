pragma solidity ^0.4.17;

import "./ERC721.sol";
//import "../../math/SafeMath.sol";

/**
 * @title ERC721Token
 * Generic implementation for the required functionality of the ERC721 standard
 */
contract ERC721Token is ERC721 {
 //using SafeMath for uint256;

  // Total amount of tokens
  uint256 private totalTitles;
  uint256 internal idModulus = 10 ** 16;   
  struct DiamondTitle {
        //#! variables will be revised shortly
        uint256 id; //#param hash id generated from xyz
        uint256 date; //#param x
        uint8 weight; //#param y
        uint8 quality; //#param z
        string labName;
    }
  DiamondTitle[] public borsettaTitles;
  // Mapping from token ID to owner
  mapping (uint256 => address) private titleOwner;

  // Mapping from token ID to approved address
  mapping (uint256 => address) private titleApprovals;

  // Mapping from owner to list of owned token IDs
  mapping (address => uint256[]) private ownedTitles;

  // Mapping from token ID to index of the owner tokens list
  mapping(uint256 => uint256) private ownedTitlesIndex;

  /**
  * @dev Guarantees msg.sender is owner of the given token
  * @param _titleId uint256 ID of the token to validate its ownership belongs to msg.sender
  */
  modifier onlyOwnerOf(uint256 _titleId) {
    require(ownerOf(_titleId) == msg.sender);
    _;
  }

  /**
  * @dev Gets the total amount of tokens stored by the contract
  * @return uint256 representing the total amount of tokens
  */
  function totalSupply() public view returns (uint256) {
    return totalTitles;
  }

  /**
  * @dev Gets the balance of the specified address
  * @param _owner address to query the balance of
  * @return uint256 representing the amount owned by the passed address
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return ownedTitles[_owner].length;
  }

  /**
  * @dev Gets the list of tokens owned by a given address
  * @param _owner address to query the tokens of
  * @return uint256[] representing the list of tokens owned by the passed address
  */
  function titlesOf(address _owner) public view returns (uint256[]) {
    return ownedTitles[_owner];
  }

  /**
  * @dev Gets the owner of the specified token ID
  * @param _titleId uint256 ID of the token to query the owner of
  * @return owner address currently marked as the owner of the given token ID
  */
  function ownerOf(uint256 _titleId) public view returns (address) {
    address owner = titleOwner[_titleId];
    require(owner != address(0));
    return owner;
  }

  /**
   * @dev Gets the approved address to take ownership of a given token ID
   * @param _titleId uint256 ID of the token to query the approval of
   * @return address currently approved to take ownership of the given token ID
   */
  function approvedFor(uint256 _titleId) public view returns (address) {
    return titleApprovals[_titleId];
  }

  /**
  * @dev Transfers the ownership of a given token ID to another address
  * @param _to address to receive the ownership of the given token ID
  * @param _titleId uint256 ID of the token to be transferred
  */
  function transfer(address _to, uint256 _titleId) public onlyOwnerOf(_titleId) {
    clearApprovalAndTransfer(msg.sender, _to, _titleId);
  }

  /**
  * @dev Approves another address to claim for the ownership of the given token ID
  * @param _to address to be approved for the given token ID
  * @param _titleId uint256 ID of the token to be approved
  */
  function approve(address _to, uint256 _titleId) public onlyOwnerOf(_titleId) {
    address owner = ownerOf(_titleId);
    require(_to != owner);
    if (approvedFor(_titleId) != 0 || _to != 0) {
      titleApprovals[_titleId] = _to;
      Approval(owner, _to, _titleId);
    }
  }

  /**
  * @dev Claims the ownership of a given token ID
  * @param _titleId uint256 ID of the token being claimed by the msg.sender
  */
  function takeOwnership(uint256 _titleId) public {
    require(isApprovedFor(msg.sender, _titleId));
    clearApprovalAndTransfer(ownerOf(_titleId), msg.sender, _titleId);
  }

  function generateId(uint8 _weight, uint8 _quality) internal view returns (uint256 titleId) {
    uint256 _date = block.timestamp;
    return uint256(keccak256(_date, _weight, _quality)) % idModulus; 
  }
  /**
  * @dev Mint token function
  * @param _to The address that will own the minted token
  * @param _titleId uint256 ID of the token to be minted by the msg.sender
  */
  function _mintTitle(address _to, uint256 _titleId, uint8 _weight, uint8 _quality, string _labName) internal {
    require(_to != address(0));
    uint256 _date = block.timestamp;
    borsettaTitles.push(DiamondTitle(_titleId, _date, _weight, _quality, _labName));
    addTitle(_to, _titleId);
    Transfer(0x0, _to, _titleId);
  }

  /**
  * @dev Burns a specific token
  * @param _titleId uint256 ID of the token being burned by the msg.sender
  */
  function _burn(uint256 _titleId) onlyOwnerOf(_titleId) internal {
    if (approvedFor(_titleId) != 0) {
      clearApproval(msg.sender, _titleId);
    }
    removeTitle(msg.sender, _titleId);
    Transfer(msg.sender, 0x0, _titleId);
  }

  /**
   * @dev Tells whether the msg.sender is approved for the given token ID or not
   * This function is not private so it can be extended in further implementations like the operatable ERC721
   * @param _owner address of the owner to query the approval of
   * @param _titleId uint256 ID of the token to query the approval of
   * @return bool whether the msg.sender is approved for the given token ID or not
   */
  function isApprovedFor(address _owner, uint256 _titleId) internal view returns (bool) {
    return approvedFor(_titleId) == _owner;
  }

  /**
  * @dev Internal function to clear current approval and transfer the ownership of a given token ID
  * @param _from address which you want to send tokens from
  * @param _to address which you want to transfer the token to
  * @param _titleId uint256 ID of the token to be transferred
  */
  function clearApprovalAndTransfer(address _from, address _to, uint256 _titleId) internal {
    require(_to != address(0));
    require(_to != ownerOf(_titleId));
    require(ownerOf(_titleId) == _from);

    clearApproval(_from, _titleId);
    removeTitle(_from, _titleId);
    addTitle(_to, _titleId);
    Transfer(_from, _to, _titleId);
  }

  /**
  * @dev Internal function to clear current approval of a given token ID
  * @param _titleId uint256 ID of the token to be transferred
  */
  function clearApproval(address _owner, uint256 _titleId) private {
    require(ownerOf(_titleId) == _owner);
    titleApprovals[_titleId] = 0;
    Approval(_owner, 0, _titleId);
  }

  /**
  * @dev Internal function to add a token ID to the list of a given address
  * @param _to address representing the new owner of the given token ID
  * @param _titleId uint256 ID of the token to be added to the tokens list of the given address
  */
  function addTitle(address _to, uint256 _titleId) private {
    require(titleOwner[_titleId] == address(0));
    titleOwner[_titleId] = _to;
    uint256 length = balanceOf(_to);
    ownedTitles[_to].push(_titleId);
    ownedTitlesIndex[_titleId] = length;
    totalTitles = totalTitles++;
  }

  /**
  * @dev Internal function to remove a token ID from the list of a given address
  * @param _from address representing the previous owner of the given token ID
  * @param _titleId uint256 ID of the token to be removed from the tokens list of the given address
  */
  function removeTitle(address _from, uint256 _titleId) private {
    require(ownerOf(_titleId) == _from);

    uint256 tokenIndex = ownedTitlesIndex[_titleId];
    uint256 lastTokenIndex = balanceOf(_from)-1;
    uint256 lastToken = ownedTitles[_from][lastTokenIndex];

    titleOwner[_titleId] = 0;
    ownedTitles[_from][tokenIndex] = lastToken;
    ownedTitles[_from][lastTokenIndex] = 0;
    // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
    // be zero. Then we can make sure that we will remove _titleId from the ownedTitles list since we are first swapping
    // the lastToken to the first position, and then dropping the element placed in the last position of the list

    ownedTitles[_from].length--;
    ownedTitlesIndex[_titleId] = 0;
    ownedTitlesIndex[lastToken] = tokenIndex;
    totalTitles = totalTitles-1;
  }
}