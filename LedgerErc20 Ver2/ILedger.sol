// SPDX-License-Identifier: MIT
pragma solidity 0.8;

// https://github.com/mosi-sol/5min/blob/main/07-IERC%20Lib/ILedgerERC20.sol
interface ILedger {
    function getResult(uint256 data) external view returns (uint256 id, address from, address to, uint256 amount, uint256 time);
    function getData(uint256 data) external view returns (bytes memory);
    event MintData(uint256 id, uint256 date, bytes data);
}
