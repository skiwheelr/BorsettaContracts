pragma solidity ^0.4.23;

import "./BorsettaTitle.sol";

contract BorsettaOperators is BorsettaTitle{
    //#TBD event TitleDataVerified(); -- ?one event for all _verify functions?  
    //   or unique event for each _verify function?
    //#TBD event OperatorAuthorized(address indexed operator, address indexed owner);

    mapping (uint256 => address) public titleOperator;
    //#map titleId : testLab (name/id)
    mapping (uint256 => address) public titleTestLab;

    event Delegation(address indexed _owner, address indexed _operator); 
    
    modifier onlyOwnerOf(uint256 _id) {
        require(ownerOf(_id) == msg.sender);
        _;
    }

    modifier onlyOperator(uint256 _id) {
        require(operatorOf(_id) == msg.sender);
        _;
    }

    modifier onlyTestLab(uint256 _id) {
        require(testLabOf(_id) == msg.sender);
        _;
    }

    //#notice assigns an authorized operator
    function delegateOperator(address _operator, address _owner, uint256 _id) public onlyOwnerOf(_id) {
        require(_operator != address(0));
        titleOperator[_id] = _operator;
        emit Delegation(_owner, _operator);
    }
    //#notice assigns an authorized test lab
    function delegateTestLab(address _testLab, address _owner, uint256 _id) public onlyOwnerOf(_id) {
        require(_testLab != address(0));
        titleTestLab[_id] = _testLab;
        emit Delegation(_owner, _testLab);
    }
    //#notice returns operator of titleId
    function operatorOf(uint256 _id) public view returns (address) {
        address operator = titleOperator[_id];
        require(operator != address(0));
        return operator;
    }
    //#notice returns test lab of titleId
    function testLabOf(uint256 _id) public view returns (address) {
        address testLab = titleTestLab[_id];
        require(testLab != address(0));
        return testLab;
    }
    //#move? cross references orignator input against test lab data, quantifies and lists discrepencies
    /**#move?

    #dev the TestLab contract will use these functions to check/update diamond data
    #dev will be revised to match appropriate variables

    function _verifyWeight(uint256 id, uint _weight) onlyTestLab internal {
        If (borsettaTitles[id][weight] != _weight) {
            borsettaTitles[id][weightDiscrepency] = borsettaTitles[id][weight] - _weight;
            borsettaTitles[id][weight] = _weight;
        }
        return;
    }

    function _verifyColor(uint256 id, uint _quality) onlyTestLab internal {
        If (borsettaTitles[id].quality != _quality) {
            borsettaTitles[id].qualityDiscrepency = borsettaTitles[id][quality] - _quality;
            borsettaTitles[id].quality = _quality;
        }
        return;
    
    function _verifyETC(etcetc) onlyTestLab internal {
        if (etcetc) {

        }
    
    }
    
    #notice function to allow external operators contracts to track possesion data

    function _trackHandling(string _name) onlyHandler internal {
        
    }
    
    function _trackVault(string _name) onylVault internal {

    }
    */
}