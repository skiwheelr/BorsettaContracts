pragma solidity ^0.4.17;

import "./BorsettaTitle.sol";

contract BorsettaOperator is BorsettaTitle {

    event DataVerified(uint256 _id, address _owner, address _testLab, uint32 _input);

    mapping (uint256=>uint8) qualityDiscrepencies;

    function _verifyQuality(DiamondTitle storage _title, uint8 _quality) internal onlyTestLab(_title.id) returns (uint8 _qualityDiscrepency) {
        if (_title.quality != _quality) {
            uint8 qualityDiscrepency = _title.quality - _quality;
            _title.quality = _quality;
            return qualityDiscrepencies[_title.id] = qualityDiscrepency;
        } else {
            return qualityDiscrepencies[_title.id] = 0; 
        }
    }




}