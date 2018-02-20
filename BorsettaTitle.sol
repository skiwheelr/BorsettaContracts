pragma solidity ^0.4.17;
                                                    //comment key
import "./ERC721.sol";                              //#dev -- explanaition
                                                    //#! -- issue
contract BorsettaTitle is ERC721 {                  //#map -- key : value (pair)
                                                    //#param -- variable            
    //#dev limits length of titleId to 16 digits    //#move? -- place c in new contract file
    uint idModulus = 10 ** 16;
    
    struct DiamondTitle {
        //#!variables will be revised shortly
        uint256 id; //#paramhash id generated from xyz
        uint256 date; //#param x
        uint8 weight; //#param y
        uint8 quality; //#param z
        string labName;
        
    }
    
    DiamondTitle[] public borsettaTitles;
    
    //#devtitleId is a sha3 hash generated from xyz
    //#devhere titleID is mapped to the index of that title in borsettaTitles array
    //#map titleId : bosettaTitles[_index];
    mapping (uint256 => uint) titleIdIndex;
    //#map titleId : address
    mapping (uint256 => address) titleToOwner;
    //#map adress : list of owned tokes
    mapping (address => uint256[]) private ownedTitles;
    //#map titleId : owneTitles[index]
    mapping (uint256 => uint256) private ownedTitlesIndex;    

    event TitleMinted(uint id, uint date, uint weight, uint quality, string labName);
    //#TBD event TitleDataVerified(); -- ?one event for all _verify functions?  
            //?or unique event for each _verify function?
    //#TBD event OperatorAuthorized(address indexed operator, address indexed owner);
    event TitleTransfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed from, address indexed to, uint256 indexed deedId);
    
    //#dev mints new title with originator specified data
    //#dev set id to uint256 version of result of sha3(_date, _weight, _quality)
    //#dev _date is set to current block height
    function _mintTitle(uint8 _weight, uint8 _quality, string _labName) private {
        uint256 _date = block.height;
        uint256 id = uint256(sha3(_date, _weight, _quality)) % idModulus;
        uint index = borsettaTitles.push(DiamondTitle(id, _date, _weight, _quality, _labName)) - 1;
        titleIdIndex[id] = index;
        titleToOwner[id] = msg.sender;
        uint _ownedTitlesIndex = ownedTitles[msg.sender].push(id) - 1;
        ownedTitlesIndex[id] = _ownedTitlesIndex;
        TitleMinted(id, _date, _weight, _quality, _labName);
    }
    
    //#move? cross references orignator input against test lab data, quantifies and lists discrepencies
    /**#move?

    #dev the TestLab contract will use these functions to check/update diamond data
    #dev will be revised to match appropriate variables

    function _verifyWeight(uint256 id, uint _weight) public;
        If (borsettaTitles[id][weight] != _weight) {
            borsettaTitles[id][weightDiscrepency] = borsettaTitles[id][weight] - _weight;
            borsettaTitles[id][weight] = _weight;
        }
        return;
    }

    function _verifyColor(uint256 id, uint _quality) {
        If (borsettaTitles[id][quality] != _quality) {
            borsettaTitles[id][qualityDiscrepency] = borsettaTitles[id][quality] - _quality;
            borsettaTitles[id][quality] = _quality;
        }
        return;
    
    function _verifyETC(etcetc) {
        if (etcetc) {

        }
    }
    }
    
    #dev function to allow external operators contracts to track possesion data

    function _trackPossesion(string _operatorName) {

    }
    */

  //#dev returns number of titles associated with address   
  function balanceOf(address _owner) public view returns (uint256) {
      return ownedTitles[_owner].length;
  }
  
  //#dev returns list of titles by titleId (hash id) owned by given address
  function titlesOf(address _owner) public view returns (uint256[]) {
    return ownedTitles[_owner];
  }
  //#dev returns owner of titleId
  function ownerOf(uint256 _id) public view returns (address) {
    address owner = titleToOwner[_id];
    require(owner != address(0));
    return owner;
  }
  //#dev returns number of titles total
  function countOfTitles() external view returns (uint256 _count) {
      return borsettaTitles.length();
  }
  //#dev returns number of titles held by owner
  function countOfTitlesByOwner(address _owner) external view returns (uint256 _count) {
      require(_owner != address(0));
      return ownedTitles[_owner].length();
  }
  //#dev returns titleId of a given adress by index (0 = 1st item in owndedTitles[address])
  //#dev does not use titleId because owndTitles is mapping of an address to an array
  //#dev not an address to mapping. Using a nested mapping would allow us to replace the index
  //#dev with a key which we would set to the titleID.
  //#dev However, I do not know if using a nested mapping here would be best or not.
  function titleOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId) {
      require(_index <= countOfTitlesByOwner(_owner));
      require(_owner != address(0));
      return ownedTitles[_owner][_index];
  }

  //#TBD function approve(address _to, uint256 _id) external payable {


  //}

  //#TBD function takeOwnership(uint256 _id) external payable {


  //}

  //#TBD function transfer(address _to, uint256 _id) external payable {


  //}
}