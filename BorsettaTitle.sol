pragma solidity ^0.4.17;
                                                    //comment key
import "./ERC721.sol";                                  //#notice -- explanation
                                                        //#! -- issue
contract BorsettaTitle is ERC721 {                      //#map -- key : value (pair)
                                                        //#param -- variable            
    //#notice limits length of titleId to 16 digits     //#move? -- place c in new contract file
    uint256 internal idModulus = 10 ** 16;              //#dev issue/task explanation/question
    uint256 private totalTitles = borsettaTitles.length();

    struct DiamondTitle {
        //#! variables will be revised shortly
        uint256 id; //#param hash id generated from xyz
        uint256 date; //#param x
        uint8 weight; //#param y
        uint8 quality; //#param z
        string labName;
        
    }
    
    DiamondTitle[] public borsettaTitles;
    //#notice here titleID is mapped to the index of that title in borsettaTitles array    
    //#param titleId is a sha3 hash generated from xyz
    //#map titleId : bosettaTitles[_index];
    mapping (uint256 => uint) private titleIdIndex;
    //#map titleId : address
    mapping (uint256 => address) internal titleToOwner;
    //#map adress : list of owned tokes
    mapping (address => uint256[]) private ownedTitles;
    //#map titleId : owneTitles[index]
    mapping (uint256 => uint256) private ownedTitlesIndex;    
    //#map titleID : approved address
    mapping (uint256 => address) private titleApprovals;
    //#map titleId : approvedOperator
    mapping (uint256 => address) private titleOperator;

    event TitleMinted(uint id, uint date, uint weight, uint quality, string labName);
    //#TBD event TitleDataVerified(); -- ?one event for all _verify functions?  
            //                      or unique event for each _verify function?
    //#TBD event OperatorAuthorized(address indexed operator, address indexed owner);
    event TitleTransfer(address indexed from, address indexed to, uint256 titles);
    event Approval(address indexed from, address indexed to, uint256 indexed id);
    event Delegation(address indexed _owner, address indexed _operator); 

    modifier onlyOwnerOf(uint256 _id) {
        require(ownerOf(_id) == msg.sender);
        _;
    }

     modifier onlyOperator(uint256 _id) {
        require(operatorOf(_id) == msg.sender);
        _;
    }
    //#notice mints new title with originator specified data
    //#param sets id to uint256 version of result of sha3(_date, _weight, _quality)
    //#param _date is set to current block height
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

    //#notice assigns an authorized operator
    function delegateOperator(address _operator) external {

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
    
    #notice function to allow external operators contracts to track possesion data

    function _trackPossesion(string _operatorName) {

    }
    */

  //#notice returns number of titles associated with address   
  function balanceOf(address _owner) public view returns (uint256) {
      return ownedTitles[_owner].length;
  }
  
  //#notice returns list of titles by titleId (hash id) owned by given address
  function titlesOf(address _owner) public view returns (uint256[]) {
    return ownedTitles[_owner];
  }
  //#notice returns owner of titleId
  function ownerOf(uint256 _id) public view returns (address) {
    address owner = titleToOwner[_id];
    require(owner != address(0));
    return owner;
  }
  //#notice returns operator of titleId
  function operatorOf(uint256 _id) public view returns (address) {
      address operator = titleOperator[_id];
      require(operator != address(0));
      return operator;
  }
  //#notice returns number of titles total
  function countOfTitles() external view returns (uint256 _count) {
      return borsettaTitles.length();
  }
  //#notice returns number of titles held by owner
  function countOfTitlesByOwner(address _owner) external view returns (uint256 _count) {
      require(_owner != address(0));
      return ownedTitles[_owner].length();
  }
  //#notice returns titleId of a given adress by index (0 = 1st item in owndedTitles[address])
  //#dev does not use titleId because ownedTitles is mapping of an address to an array
  //#dev not a mapping of address to mapping. Using a nested mapping would allow us to replace the 
  //#dev index with a key which we would set to the titleID.
  //#dev However, I do not know if using a nested mapping here would be best or not.
  function titleOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId) {
      require(_index <= countOfTitlesByOwner(_owner));
      require(_owner != address(0));
      return ownedTitles[_owner][_index];
  }

  function approvedFor(uint256 _id) public view returns (address) {
    return titleApprovals[_id];
  }

  function approve(address _to, uint256 _id) public onlyOwnerOf(_id) {
    address owner = ownerOf(_id);
    require(_to != owner);
    if (approvedFor(_id) != 0 || _to != 0) {
      titleApprovals[_id] = _to;
      Approval(owner, _to, _id);
    }
  }

  function isApprovedFor(address _owner, uint256 _id) internal view returns (bool) {
    return approvedFor(_id) == _owner;
  }
  //#TBD function takeOwnership(uint256 _id) external payable {


  //}

  function transfer(address _to, uint256 _id) public onlyOwnerOf(_id) {
    clearApprovalAndTransfer(msg.sender, _to, _id);
  }

  function takeOwnership(uint256 _id) public {
    require(isApprovedFor(msg.sender, _id));
    clearApprovalAndTransfer(ownerOf(_id), msg.sender, _id);
  }

  function clearApprovalAndTransfer(address _from, address _to, uint256 _id) internal {
    require(_to != address(0));
    require(_to != ownerOf(_id));
    require(ownerOf(_id) == _from);

    clearApproval(_from, _id);
    removeToken(_from, _id);
    addToken(_to, _id);
    Transfer(_from, _to, _id);
  }

  function clearApproval(address _owner, uint256 _id) private {
    require(ownerOf(_id) == _owner);
    titleApprovals[_id] = 0;
    Approval(_owner, 0, _id);
  }

  function addToken(address _to, uint256 _id) private {
    require(titleToOwner[_id] == address(0));
    titleToOwner[_id] = _to;
    uint256 length = balanceOf(_to);
    ownedTitles[_to].push(_id);
    ownedTitlesIndex[_id] = length;
    totalTitles = totalTitles.add(1);
  }

  function removeToken(address _from, uint256 _id) private {
    require(ownerOf(_id) == _from);

    uint256 index = ownedTitlesIndex[_id];
    uint256 lastindex = balanceOf(_from).sub(1);
    uint256 lastToken = ownedTitles[_from][lastindex];

    titleToOwner[_id] = 0;
    ownedTitles[_from][index] = lastToken;
    ownedTitles[_from][lastindex] = 0;
    // Note that this will handle single-element arrays. In that case, both index and lastindex are going to
    // be zero. Then we can make sure that we will remove _id from the ownedTokens list since we are first swapping
    // the lastToken to the first position, and then dropping the element placed in the last position of the list

    ownedTitles[_from].length--;
    ownedTitlesIndex[_id] = 0;
    ownedTitlesIndex[lastToken] = index;
    totalTitles = totalTitles.sub(1);
  }
  //#TBD function supportsInterface(bytes4 interfaceID) external view returns (bool) {

  //}
}