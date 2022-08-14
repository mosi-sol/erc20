// SPDX-License-Identifier: MIT
pragma solidity 0.8;

import "github.com/mosi-sol/5min/blob/main/07-IERC%20Lib/IERC20/IERC20.sol";
import "github.com/mosi-sol/5min/blob/main/07-IERC%20Lib/IERC20/IERC20Metadata.sol";

// https://github.com/mosi-sol/5min/blob/main/07-IERC%20Lib/ILedgerERC20.sol
interface ILedger {
    function getResult(uint256 data) external view returns (uint256 id, address from, address to, uint256 amount, uint256 time);
    function getData(uint256 data) external view returns (bytes memory);
    event MintData(uint256 id, uint256 date, bytes data);
}

abstract contract ERC20 is IERC20, IERC20Metadata, ILedger {
    // ========== variables ========== \\
    string private _name;
    string private _symbol;
    uint8 private _decimals = 18; // constant
    uint256 private _totalSupply;
    uint256 private _ledgerId;

    mapping(address => uint256) private _balanceOf;
    mapping(address => mapping (address => uint256)) private _allowed;
    mapping(uint256 => bytes) private _hashed;

    // ========== init ========== \\
    constructor(string memory name_, string memory symbol_/*, uint8 decimals_*/) {
        _name = name_;
        _symbol = symbol_;
        /*_decimals = decimals_;*/
        _ledgerId = 0;
        // _balanceOf[msg.sender] = _totalSupply; // this is for non-mintable tokens {remember to set value on totalsupply}
    }

    // ========== readonly ========== \\
    function name() external virtual override view returns (string memory){
        return _name;
    }

    function symbol() external virtual override view returns (string memory){
        return _symbol;
    }

    function decimals() external virtual override view returns (uint8){
        return _decimals;
    }

    function totalSupply() external virtual override view returns (uint){
        return _totalSupply;
    }

    function balanceOf(address account) external virtual override view returns (uint){
        return _balanceOf[account];
    }

    function allowance(address owner, address spender) external virtual override view returns (uint){
        return _allowed[owner][spender];
    }

    // ========== basic ========== \\
    function approve(address spender, uint amount) external virtual override returns (bool){
        return _approve(spender, amount);
    }

    function transfer(address recipient, uint amount) external virtual override returns (bool){
        return _transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) external virtual override returns (bool){
        _allowed[sender][msg.sender] += amount;
        return _transferFrom(sender, recipient, amount);
    }

    function _approve(address spender, uint amount) internal returns (bool){
        _allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function _transfer(address recipient, uint amount) internal returns (bool){
        require(amount <= _balanceOf[msg.sender]);
        _balanceOf[msg.sender] = _balanceOf[msg.sender] - amount;
        _balanceOf[recipient] = _balanceOf[recipient] + amount;
        emit Transfer(msg.sender, recipient, amount);
        _compressData(amount, recipient);
        return true;
    }

    function _transferFrom(address sender, address recipient, uint amount) internal returns (bool){
        require(sender != address(0), "Error: sender can not be address 0!");
        require(recipient != address(0), "Error: recipient can not be address 0!");
        require(amount <= _balanceOf[sender]);
        require(amount <= _allowed[sender][msg.sender]);
        unchecked {
            _balanceOf[sender] = _balanceOf[sender] - amount;
            _allowed[sender][msg.sender] = _allowed[sender][msg.sender] - amount;
        }        
        _balanceOf[recipient] = _balanceOf[recipient] + amount;
        emit Transfer(sender, recipient, amount);
        _compressData(amount, sender, recipient);
        return true;
    }

    // ========== allowance features ========== \\
    function incressAllowance(address spender, uint amount) external {
        _incressAllowance(spender, amount);
    }
    
    function decressAllowance(address spender, uint amount) external{
        _decressAllowance(spender, amount);
    }

    function _incressAllowance(address spender, uint amount) internal{
        _allowed[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    }
    
    function _decressAllowance(address spender, uint amount) internal{
        unchecked {
            _allowed[msg.sender][spender] -= amount;
        }
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    }

    // ========== generate/destroy ========== \\
    function _mint(address to, uint256 amount) internal virtual returns (bool) {
        require(to != address(0), "Error: recipient can not be address 0!");
        _balanceOf[to] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), to, amount);
        _compressData(amount, address(0), to);
        return true;
    }

    function _burn(address from, uint256 amount) internal virtual returns (bool) {
        require(from != address(0), "Error: recipient can not be address 0!");
        uint256 accountBalance = _balanceOf[from];
        require(accountBalance >= amount, "Warning: burn amount more than the balance");
        unchecked { _balanceOf[from] = accountBalance - amount; }
        _totalSupply -= amount;
        emit Transfer(from, address(0), amount);
        _compressData(amount, address(0));
        return true;
    }

    // ========== ledger ========== \\
    function _compressData(uint256 amount, address to) internal returns (bytes memory _crypto){
        _crypto = bytes(abi.encode(_ledgerId, msg.sender, to, amount, block.timestamp));
        _hashed[_ledgerId] = _crypto;
        emit MintData(_ledgerId, block.timestamp, _crypto);
        _ledgerId += 1;
    }

    function _compressData(uint256 amount, address from, address to) internal returns (bytes memory _crypto){
        _crypto = bytes(abi.encode(_ledgerId, from, to, amount, block.timestamp));
        _hashed[_ledgerId] = _crypto;
        emit MintData(_ledgerId, block.timestamp, _crypto);
        _ledgerId += 1;
    }

    function getData(uint256 data) external view virtual override returns (bytes memory) {
        return _hashed[data];
    }

    function getResult(uint256 data) external view virtual override returns (uint256 id, address from, address to, uint256 amount, uint256 time) {
        bytes memory info = _hashed[data];
        (id, from, to, amount, time) = abi.decode(info, (uint256, address, address, uint256, uint256));
    }

}


/*====================
test by: mock example
====================*/

contract Mock is ERC20 {
    constructor(string memory name_, string memory symbol_/*, uint8 decimals_*/) 
    ERC20(name_, symbol_/*, decimals_*/) {}

    function testMint() public {
        _mint(msg.sender, 100);
    }

    function testBurn() public {
        _mint(msg.sender, 5);
    }

    function testTransfer(address recipient) public {
        _transfer(recipient, 10);
    }

    function testTransferFrom(address recipient) public {
        _transferFrom(msg.sender, recipient, 15);
    }
}
