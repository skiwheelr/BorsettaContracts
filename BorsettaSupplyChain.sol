pragma solidity ^0.4.23;

import "./BorsettaTitle.sol";

contract BorsettaSupplyChain is BorsettaTitle {

    event testLabVerification(address indexed _testLab, bytes32 _proof, uint256 _titleId);
    event transportation(address indexed _transport, bytes32 _proof, uint256 _titleId);
    event vaultStorage(address indexed _vault, bytes32 _proof, uint256 _titleId);

    modifier accessGranted(uint256 _titleId, bytes32 _accessKey) {
        uint index = borsettaTitlesIndex[_titleId];
        require(_accessKey == borsettaTitles[index].accessKey);
        _;
    }

    function verifyWeight(uint256 _titleId, bytes32 _accessKey, uint8 _weight, uint8 _quality, uint8 _color) 
     internal accessGranted(_titleId, _accessKey) {

        uint index = borsettaTitlesIndex[_titleId];
        if (_weight != borsettaTitles[index].weight) {
            uint8 weightDiscrepency = borsettaTitles[index].weight - _weight;
        } else {weightDiscrepency = 0;}

        if (_quality != borsettaTitles[index].quality) {
            uint8 qualityDiscrepency = borsettaTitles[index].quality - _quality;
        } else {qualityDiscrepency = 0;}

        if (_color != borsettaTitles[index].color) {
            uint8 colorDiscrepency = borsettaTitles[index].color - _color;
        } else {colorDiscrepency = 0;}

        bytes32 _proof = keccak256(weightDiscrepency, qualityDiscrepency, colorDiscrepency);

        borsettaTitles[index].discrepencyProofs.push(_proof);
        
        emit testLabVerification(msg.sender, _proof, _titleId);
    }


    function diamondTransport(uint256 _titleId, bytes32 _accessKey) internal accessGranted(_titleId, _accessKey) {
        bytes32 _proof = keccak256(0);
        
        emit transportation(msg.sender, _proof, _titleId);
    }

    function diamondVaultStorage(uint256 _titleId, bytes32 _accessKey) internal accessGranted(_titleId, _accessKey) {
        bytes32 _proof = keccak256(0);
        
        emit vaultStorage(msg.sender, _proof, _titleId);
    }

}