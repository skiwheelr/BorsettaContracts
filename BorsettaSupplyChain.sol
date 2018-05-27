pragma solidity ^0.4.23;

import "./BorsettaTitle.sol";

contract BorsettaSupplyChain is BorsettaTitle {

/**
* @dev events to log actions in front-end
* @param _address indexed represents the address of given supply chain stakeholder
* @param _proof metadata hash used to verify validity of off-chain data by reproducing hash
* @param _titleId represents ID of working title
 */
    event testLabVerification(address indexed _testLab, bytes32 _proof, uint256 _titleId);
    event transportation(address indexed _transport, bytes32 _proof, uint256 _titleId);
    event vaultStorage(address indexed _vault, bytes32 _proof, uint256 _titleId);

/**
* @dev modifier grants access to parties with correct access key stored on rfid/diamond nanotech tracking device
* @dev throws if accessKey does not match 
* @param _titleId represents ID of working title
* @param _accessKey represents bytes32 hash of working title accessKey
 */
    modifier accessGranted(uint256 _titleId, bytes32 _accessKey) {
        uint index = borsettaTitlesIndex[_titleId];
        require(_accessKey == borsettaTitles[index].accessKey);
        _;
    }

/**
* @dev compares manufacturer diamond attributes to testLab diamond attributes
* @dev creates a metadata hash (proof) used to verify off data stored off-chain
* @dev stores proof in title struct
* @todo change to three seperate functions (weightDiscrepency, qualityDiscrepency, colorDiscrepency) 
*  that takes in _discrency arguments and creates individual proofs for each attribute
* @param _titleId represents ID of working title
* @param _accessKey represents bytes32 hash of working title accessKey
* @param _weight uint8 representing testLab input for weight
* @param _quality uint8 representing testLab input for quality
* @param _color uint8 representing testLab input for color
 */
    function verifyAttributes(
        uint256 _titleId, 
        bytes32 _accessKey, 
        uint8 _weight, 
        uint8 _quality, 
        uint8 _color
        )  internal accessGranted(_titleId, _accessKey) {

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

/**
* @dev takes in transport metadata and generates proof (metadata hash) used to verify off-chain data
* @dev stores proof in title struct
* @param _titleId represents ID of working title
* @param _accessKey represents bytes32 hash of working title accessKey
* @param _transportName string represent name of transport company
* @param _startCoordinates uint256 stores gps coordinates of pickup location
* @param _endCoordinates uint256 represents gps coordinates of end location
* @param _elapsedTime uint256 represents total time used to transport diamond
 */
    function diamondTransport(
        uint256 _titleId, 
        bytes32 _accessKey, 
        string _transportName, 
        uint256 _startCoordinates, 
        uint256 _endCoordinates,
        uint256 _elapsedTime
        ) internal accessGranted(_titleId, _accessKey) {
      //solium prevent arg-line overflow
        bytes32 _proof = keccak256(_transportName, _startCoordinates, _endCoordinates, _elapsedTime);
        
        uint index = borsettaTitlesIndex[_titleId];
        borsettaTitles[index].transportationProofs.push(_proof);

        emit transportation(msg.sender, _proof, _titleId);
    }

/**
* @dev takes in vault metadata and generates proof (metadata hash) used to verify off-chain data
* @dev stores proof in title struct
* @param _titleId represents ID of working title
* @param _accessKey represents bytes32 hash of working title accessKey
* @param _vaultName string represents name of vault company
* @param _vaultAddress represents address of vault
* @param _date uint256 represents date and time of vault recieving diamond
 */
    function diamondVaultStorage(
        uint256 _titleId, 
        bytes32 _accessKey, 
        string _vaultName, 
        string _vaultAddress,
        uint256 _date
        ) internal accessGranted(_titleId, _accessKey) {
      //solium prevent arg-line overflow            
        bytes32 _proof = keccak256(_vaultName, _vaultAddress, _date);

        uint index = borsettaTitlesIndex[_titleId];
        borsettaTitles[index].vaultStorageProofs.push(_proof);
        
        emit vaultStorage(msg.sender, _proof, _titleId);
    }

}