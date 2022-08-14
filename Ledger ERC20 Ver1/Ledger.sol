// SPDX-License-Identifier: MIT
pragma solidity 0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/*
    maximum transaction before overflow OR maximum transaction id using for ledger
    uint256 MAX_INT = 115792089237316195423570985008687907853269984665640564039457584007913129639935
    uint256 MAX_INT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    uint256 MAX_INT = uint256(-1)
    uint256 MAX_INT = 2**256 - 1
*/

// ledger: basic version. not track asset`s by approved
interface ILedger {

    event HashData(uint256 hashId, bytes hash); // hashId = txId

    function getData(uint256 hashId) external view returns (bytes memory);

    function getResult(uint256 hashId) external view returns (uint256 amount, address to, uint256 time, address from); 

}

abstract contract ERC20LedgerV21 is ILedger, ERC20{
    using Counters for Counters.Counter;

    Counters.Counter private _hashIdCounter;

    mapping(uint256 => bytes) private _hashed;

    // ========== init ========== \\
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_){}

    // ========== incalculateit ========== \\
    function _hashedMint(uint256 amount, address to) internal view returns (bytes memory _crypto){
        _crypto = bytes(abi.encode(amount, to, block.timestamp, msg.sender));
    }

    function getData(uint256 id) external view virtual override returns (bytes memory) {
        return _hashed[id];
    }

    function getResult(uint256 id) external view virtual override returns (uint256 amount, address to, uint256 time, address from) {
        require(id < _hashIdCounter.current(), "not exist");
        bytes memory data = _hashed[id];
        (amount, to, time, from) = abi.decode(data, (uint256, address, uint256, address));
    }

    // ========== override ========== \\
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        uint256 hashId = _hashIdCounter.current();
        _hashIdCounter.increment();
        _hashed[hashId] = _hashedMint(amount, to);
        emit HashData(block.timestamp, _hashed[hashId]);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        uint256 hashId = _hashIdCounter.current();
        _hashIdCounter.increment();
        _hashed[hashId] = _hashedMint(amount, to);
        emit HashData(block.timestamp, _hashed[hashId]);
        return true;
    }

    function mint(address to, uint256 amount) public virtual {
        _mint(to, amount);
        uint256 hashId = _hashIdCounter.current();
        _hashIdCounter.increment();
        _hashed[hashId] = _hashedMint(amount, to);
        emit HashData(block.timestamp, _hashed[hashId]);
    }

    function burn(uint256 amount) public virtual {
        _burn(msg.sender, amount);
        uint256 hashId = _hashIdCounter.current();
        _hashIdCounter.increment();
        _hashed[hashId] = _hashedMint(amount, msg.sender);
        emit HashData(block.timestamp, _hashed[hashId]);
    }

}

contract Mock is ERC20LedgerV21 {
    address ad1 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    constructor(string memory _name, string memory _symbol) ERC20LedgerV21(_name, _symbol){
        mint(msg.sender, 1000 * 10 ** 18);
    }

    function test1() public {
        burn(10);
    }

    function test2() public {
        transfer(ad1, 100);
    }

    function test3() public {
        approve(msg.sender, 1000);
        transferFrom(msg.sender, ad1, 1000);
    }
}
