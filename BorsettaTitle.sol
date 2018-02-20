pragma solidity ^0.4.17;

import "./ERC721.sol";

contract BorsettaTitle is ERC721 {
    
    event TitleMinted(uint id, uint date, uint weight, uint quality, string labName);
    //TBD! event TitleDataVerified(); -- ?one event for all _verify functions?  
            //?or unique event for each _verify function?
    //TBD! event OperatorAuthorized(address indexed operator, address indexed owner);
    event TitleTransfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed from, address indexed to, uint256 indexed deedId);
    
    uint idModulus = 10 ** 16;
    
    struct DiamondTitle {
        //variables will be revised shortly
        uint256 id; //hash id generated from xyz
        uint date; //x
        uint weight; //y
        uint quality; //z
        string labName;
        
    }
    
    DiamondTitle[] public borsettaTitles;
    
    //!titleId is a sha3 hash generated from xyz
    //!here titleID is mapped to the index of that title in borsettaTitles array
    // titleId : bosettaTitles[_index];
    mapping (uint256 => uint) titleIdIndex;
    // titleId : address
    mapping (uint256 => address) titleToOwner;
    // adress : list of owned tokes
    mapping (address => uint256[]) private ownedTitles;
    //?*remove ownedTitlesIndex*?
    // titleId : owneTitles[index]
    mapping (uint256 => uint256) private ownedTitlesIndex;    
    
    //mints new title with originator specified data
    function _mintTitle(uint _date, uint _weight, uint _quality, string _labName) private {
        //issue#1 - replace id with sha3 hash of input data
        uint256 id = uint256(sha3(_date, _weight, _quality));
        uint index = borsettaTitles.push(DiamondTitle(id, _date, _weight, _quality, _labName)) - 1;
        titleIdIndex[id] = index;
        titleToOwner[id] = msg.sender;
        uint _ownedTitlesIndex = ownedTitles[msg.sender].push(id) - 1;
        ownedTitlesIndex[id] = _ownedTitlesIndex;
        TitleMinted(id, _date, _weight, _quality, _labName);
    }
    
    //move? cross references orignator input against test lab data, quantifies and lists discrepencies
    /**move?

    the TestLab contract will use these functions to check/update diamond data
    will be revised to match appropriate variables

    function _verifyWeight(uint id, uint _weight) public;
        If (borsettaTitles[id][weight] != _weight) {
            borsettaTitles[id][weightDiscrepency] = borsettaTitles[id][weight] - _weight;
            borsettaTitles[id][weight] = _weight;
        }
        return;
    }

    function _verifyColor(uint id, uint _quality) {
        If (borsettaTitles[id][quality] != _quality) {
            borsettaTitles[id][qualityDiscrepency] = borsettaTitles[id][quality] - _quality;
            borsettaTitles[id][quality] = _quality;
        }
        return;
    
    function _verifyETC() {
        
    }
    }
    
    */

  //returns number of titles associated with address   
  function balanceOf(address _owner) public view returns (uint256) {
      return ownedTitles[_owner].length;
  }
  
  //returns list of titles by titleId (hash id) owned by given address
  function titlesOf(address _owner) public view returns (uint256[]) {
    return ownedTitles[_owner];
  }

  function ownerOf(uint256 _id) public view returns (address) {
    address owner = titleToOwner[_id];
    require(owner != address(0));
    return owner;
  }

  function countOfTitles() external view returns (uint256 _count) {
      return borsettaTitles.length();
  }

  function countOfTitlesByOwner(address _owner) external view returns (uint256 _count) {
      require(_owner != address(0));
      return ownedTitles[_owner].length();
  }
  
  // returns titleId of a given adress by index (0 = 1st item in owndedTitles[address])
  // does not use titleId because owndTitles is mapping of an address to an array
  // not an address to mapping. Using a nested mapping would allow us to replace the index
  // with a key which we would set to the titleID.
  // However, I do not know if using a nested mapping here would be best or not.
  
  function titleOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId) {
      require(_index <= countOfTitlesByOwner(_owner));
      require(_owner != address(0));
      return ownedTitles[_owner][_index];
  }

  //TBD! function approve(address _to, uint256 _deedId) external payable {


  //}

  //TBD! function takeOwnership(uint256 _deedId) external payable {


  //}

  //TBD! function transfer(address _to, uint256 _deedId) external payable {


  //}
}