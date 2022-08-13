// SPDX-License-Identifier: MIT
pragma solidity 0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

// ledger: basic version. not track asset`s by approved
interface ILedger {
    event MintData(uint256 date);

    function getData(uint256 date) external view returns (bytes memory);

    function getResult(uint256 date) external view returns (uint256 amount, address to, uint256 time, address minter);

}

abstract contract ERC20 is IERC20, IERC20Metadata, ILedger {

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => uint256) private _spender;
    mapping(uint256 => bytes) private _hashed;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // ==============================================================================
    function name() external virtual override view returns (string memory){
        return _name;
    }

    function symbol() external virtual override view returns (string memory){
        return _symbol;
    }

    function decimals() external virtual override view returns (uint8){
        return 18;
    }

    // ==============================================================================
    function totalSupply() external virtual override view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address account) external virtual override view returns (uint256){
        return _balances[account];
    }

    function _balanceOf(address account) internal view returns (uint256){
        return _balances[account];
    }

    function allowance(address owner, address spender) external virtual override view returns (uint256){
        return _allowances[owner][spender];
    }

    // ==============================================================================
    function transfer(address to, uint256 amount) external virtual override returns (bool){
        require(_beforTransfer(msg.sender, to), "Wrong: target address can not be trash address!");
        require(_balances[msg.sender] >= amount || _approved(msg.sender) >= amount, "Error: insufficient balance");
        bool success = _transferFrom(msg.sender, to, amount);
        return success;
    }

    function transferFrom(address from, address to, uint256 amount ) external virtual override returns (bool){
        require(_beforTransfer(from, to), "Wrong: target address`s can not be trash address!");
        require(_balances[from] >= amount || _approved(from) >= amount, "Error: insufficient balance");
        bool success = _transferFrom(msg.sender, to, amount);
        return success;
    }

    function approve(address spender, uint256 amount) external virtual override returns (bool){
        require(_balances[msg.sender] >= amount || _approved(msg.sender) >= amount, "Error: insufficient balance");
        return _approve(spender, amount);
    }

    // ==============================================================================
    function incressAllowance(address spender, uint256 amount) external{
        require(_balances[msg.sender] >= amount, "Error: insufficient allowance");
        _incressAllowance(spender, amount);
    }

    function deccressAllowance(address spender, uint256 amount) external{
        require(_balances[msg.sender] >= amount, "Error: insufficient allowance");
        _decressAllowance(spender, amount);
    }

    // ==============================================================================
    function _mint(address to, uint256 amount) internal returns (bool){
        (bool fine, bytes memory data) = msg.sender.call(
            abi.encodeWithSignature("_transferFrom(address,address,uint256)", address(0), to, amount)
        );
        require(fine && (data.length == 0 || abi.decode(data, (bool))),
            "Warning: Transaction failed");
        _totalSupply += amount;
        _balances[to] += amount;
        _approve(to, amount);
        _hashed[block.timestamp] = _hashedMint(amount, to);
        emit Transfer(address(0), to, amount);
        emit MintData(block.timestamp);
        return true;
    }

    function _burn(address from, uint256 amount) internal returns (bool){
        require(msg.sender == from);
        (bool fine, bytes memory data) = msg.sender.call(
            abi.encodeWithSignature("_transferFrom(address,address,uint256)", from, address(0), amount)
        );
        require(fine && (data.length == 0 || abi.decode(data, (bool))),
            "Warning: Transaction failed");
        uint256 accountBalance = _balances[from];
        require(accountBalance >= amount, "Wrong: burn amount exceeds balance");
        unchecked {
            _balances[from] = accountBalance - amount;
        }
        _totalSupply -= amount;
        _hashed[block.timestamp] = _hashedMint(amount, address(0));
        emit MintData(block.timestamp);
        emit Transfer(from, address(0), amount);
        return true;
    }

    // ==============================================================================
    function _hashedMint(uint256 amount, address to) internal view returns (bytes memory _crypto){
        _crypto = bytes(abi.encode(amount, to, block.timestamp, msg.sender));
    }

    function getData(uint256 date) external view virtual override returns (bytes memory) {
        return _hashed[date];
    }

    function getResult(uint256 date) external view virtual override returns (uint256 amount, address to, uint256 time, address minter) {
        bytes memory data = _hashed[date];
        (amount, to, time, minter) = abi.decode(data, (uint256, address, uint256, address));
    }

    // ==============================================================================
    function _transfer(address to, uint256 amount) internal{
        uint256 tmp = _balances[msg.sender];
        unchecked {
            _balances[msg.sender] = tmp - amount;
        }
        address spender = msg.sender;
        _spendAllowance(spender, amount);
        (bool fine, bytes memory data) = msg.sender.call(
            abi.encodeWithSignature("_transfer(address,uint256)", to, amount)
        );
        require(fine && (data.length == 0 || abi.decode(data, (bool))),
            "Warning: Transaction failed");
        _balances[to] += amount;
        _approve(to, amount);
        _hashed[block.timestamp] = _hashedMint(amount, to);
        emit MintData(block.timestamp);
        emit Transfer(msg.sender, to, amount);
    }

    function _transferFrom(address from, address to, uint256 amount ) internal returns (bool){
        uint256 tmp = _balances[from];
         unchecked {
            _balances[from] = tmp - amount;
        }
        address spender = msg.sender;
        _spendAllowance(spender, amount);
        (bool fine, bytes memory data) = msg.sender.call(
            abi.encodeWithSignature("_transferFrom(address,address,uint256)", msg.sender, to, amount)
        );
        require(fine && (data.length == 0 || abi.decode(data, (bool))),
            "Warning: Transaction failed");
        _balances[to] += amount;
        _approve(to, amount);
        _hashed[block.timestamp] = _hashedMint(amount, to);
        emit MintData(block.timestamp);
        emit Transfer(from, to, amount);
        return true;
    }

    function _beforTransfer(address from, address to) private pure returns (bool){
        require(from != address(0));
        require(to != address(0));
        return true;
    }

    function _beforTransfer(address account) private pure returns (bool){
        require(account != address(0));
        return true;
    }

    function _approve(address spender, uint256 amount) internal returns (bool){
        require(_spender[spender] != type(uint256).max);
        _allowances[msg.sender][spender] = amount;
        _spender[spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function _incressAllowance(address spender, uint256 amount) internal{
        require(_spender[spender] != type(uint256).max);
        _allowances[msg.sender][spender] += amount;
        _spender[spender] += amount;
    }

    function _decressAllowance(address spender, uint256 amount) internal{
        unchecked {
            _allowances[msg.sender][spender] -= amount;
        }
    }
    
    function _spendAllowance(
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = _spender[spender];
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "Error: insufficient allowance");
            unchecked {
                _approve(spender, currentAllowance - amount);
            }
        }
    }

    function _approved(address spender) internal view returns (uint256){
        return _spender[spender];
    }

}


// MOCK ERC20 ==================================
contract MockERC20 is ERC20 {
    constructor() ERC20("Mock Token", "MTK"){}
    
    function mint(address to, uint256 amount) external /*onlyOwner*/ returns (bool success){
        require(to != address(0), "Wrong: target address`s can not be trash address!");
        success = _mint(to, amount);
    }

    function burn(uint256 amount) external returns (bool success){
        require(msg.sender != address(0), "Wrong: target address`s can not be trash address!");
        uint256 tmp = _balances(msg.sender); 
        require(tmp >= amount, "Error: insufficient allowance");
        success = _burn(msg.sender, amount);
    }

    function _balances(address account) private view returns (uint256){
        return _balanceOf(account);
    }
}
