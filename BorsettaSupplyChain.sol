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
    event proofVerification(uint256 _titleId, bool _verification);

/**
* @dev take input from testLab and creates a metadata hash (proof) used to verify off data stored off-chain
* @dev stores proof in title struct
* @param _titleId represents ID of working title
* @param _accessKey represents bytes32 hash of working title accessKey
* @param _weightDiscrepency uint8 representing testLab input for weightDiscrepency -- use 0 when manufacture input is accurate
* @param _qualityDiscrepency uint8 representing testLab input for qualityDiscrepency -- use 0 when manufacture input is accurate
* @param _colorDiscrepency uint8 representing testLab input for colorDiscrepency -- use 0 when manufacture input is accurate
 */
    function discrepenciesProof(
        uint256 _titleId, 
        bytes32 _accessKey, 
        string _key,
        uint8 _weightDiscrepency, 
        uint8 _qualityDiscrepency, 
        uint8 _colorDiscrepency
    ) internal  accessGranted(_titleId, _accessKey) {
      //solium prevent arg-line overflow
        bytes32 _proof = keccak256(_weightDiscrepency, _qualityDiscrepency, _colorDiscrepency);
        
        uint index = borsettaTitlesIndex[_titleId];
        borsettaTitles[index].discrepencyProofs[_key] = _proof;

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
    function transportationProof(
        uint256 _titleId, 
        bytes32 _accessKey, 
        string _key,
        string _transportName, 
        uint256 _startCoordinates, 
        uint256 _endCoordinates,
        uint256 _elapsedTime
        ) internal accessGranted(_titleId, _accessKey) {
      //solium prevent arg-line overflow
        bytes32 _proof = keccak256(_transportName, _startCoordinates, _endCoordinates, _elapsedTime);
        
        uint index = borsettaTitlesIndex[_titleId];
        borsettaTitles[index].transportationProofs[_key] = _proof;

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
    function vaultStorageProof(
        uint256 _titleId, 
        bytes32 _accessKey, 
        string _key,
        string _vaultName, 
        string _vaultAddress,
        uint256 _date
        ) internal accessGranted(_titleId, _accessKey) {
      //solium prevent arg-line overflow            
        bytes32 _proof = keccak256(_vaultName, _vaultAddress, _date);

        uint index = borsettaTitlesIndex[_titleId];
        borsettaTitles[index].vaultStorageProofs[_key] = _proof;
        
        emit vaultStorage(msg.sender, _proof, _titleId);
    }

    /**
    * @dev retrieve discrepency proof by key
    * @param _titleId represents ID of working title
    * @param _key represents the key used to store the proof in the discrepencyProofs mapping (key/val pair aka (key => val))
    * @return bool true if input 
    * @param _weightDiscrepency uint8 representing testLab input for weightDiscrepency -- use 0 when manufacture input is accurate
    * @param _qualityDiscrepency uint8 representing testLab input for qualityDiscrepency -- use 0 when manufacture input is accurate
    * @param _colorDiscrepency uint8 representing testLab input for colorDiscrepency -- use 0 when manufacture input is accurate
     */
    function verifyDiscrepency(
        uint256 _titleId,
        string _key,
        uint8 _weightDiscrepency, 
        uint8 _qualityDiscrepency, 
        uint8 _colorDiscrepency) 
        public returns(bool) {
      //solium prevent arg-line overflow         
        uint256 index = borsettaTitlesIndex[_titleId];

        bool verification = borsettaTitles[index].discrepencyProofs[_key] == keccak256(
            _weightDiscrepency, 
            _qualityDiscrepency, 
            _colorDiscrepency);
      //solium prevent arg-line overflow    

        emit proofVerification(_titleId, verification); 

        return verification;    
    }
}