pragma solidity ^0.4.17;
/// @title Optional metadata extension to ERC-721 Deed Standard
/// @author William Entriken (https://phor.net)
/// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
///  Note: the ERC-165 (DRAFT) identifier for this interface is 0x2a786f11

interface ERC721Metadata /* is ERC721 */ {

    /// @notice A descriptive name for a collection of deeds in this contract
    function name() external pure returns (string _name);

    /// @notice An abbreviated name for deeds in this contract
    function symbol() external pure returns (string _symbol);

    /// @notice A distinct Uniform Resource Identifier (URI) for a given deed.
    /// @dev Throws if `_deedId` is not a valid deed. URIs are defined in RFC
    ///  3986. The URI may point to a JSON file that conforms to the "ERC721
    ///  Metadata JSON Schema".
    function titleUri(uint256 _id) external view returns (string _titleUri);
}