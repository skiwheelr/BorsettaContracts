pragma solidity ^0.4.17;
/// @title Optional enumeration extension to ERC-721 Deed Standard
/// @author William Entriken (https://phor.net)
/// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
///  Note: the ERC-165 (DRAFT) identifier for this interface is 0x5576ab6a
interface ERC721Enumerable /* is ERC721 */ {
    /// @notice Count deeds tracked by this contract
    /// @return A count of valid deeds tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() external view returns (uint256 _count);

    /// @notice Enumerate active deeds
    /// @dev Throws if `_index` >= `countOfDeeds()`.
    ///  Otherwise must not throw.
    /// @param _index A counter less than `countOfDeeds()`
    /// @return The identifier for the `_index`th deed, (sort order not
    ///  specified)
    function deedByIndex(uint256 _index) external view returns (uint256 _deedId);

    /// @notice Count of owners which own at least one deed
    ///  Must not throw.
    /// @return A count of the number of owners which own deeds
    function countOfOwners() external view returns (uint256 _count);

    /// @notice Enumerate owners
    /// @dev Throws if `_index` >= `countOfOwners()`
    ///  Otherwise must not throw.
    /// @param _index A counter less than `countOfOwners()`
    /// @return The address of the `_index`th owner (sort order not specified)
    function ownerByIndex(uint256 _index) external view returns (address _owner);

    /// @notice Enumerate deeds assigned to an owner
    /// @dev Throws if `_index` >= `countOfDeedsByOwner(_owner)` or if
    ///  `_owner` is the zero address, representing invalid deeds.
    ///  Otherwise this must not throw.
    /// @param _owner An address where we are interested in deeds owned by them
    /// @param _index A counter less than `countOfDeedsByOwner(_owner)`
    /// @return The identifier for the `_index`th deed assigned to `_owner`,
    ///   (sort order not specified)
    function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId);
}