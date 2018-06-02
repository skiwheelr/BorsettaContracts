pragma solidity ^0.4.23;

import "./BorsettaTitle.sol";

contract BorsettaTransfers is BorsettaTitle {

    function approve(address _to, uint256 _titleId, bytes32 _accessKey) public accessGranted(_titleId, _accessKey) {
        ERC721BasicToken.approve(_to, _titleId);
    }

    function setApprovalForOperator(
        address _operator, 
        uint256 _titleId, 
        bytes32 _accessKey, 
        bool _approved) public accessGranted(_titleId, _accessKey) {
      // solium prevent arg-line overflow
        ERC721BasicToken.setApprovalForOperator(_operator, _titleId, _approved);
    }
}