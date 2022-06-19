// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract ERC20 is IERC20 {

    // can not transfer %$1, %$2
    error NotTransfer(uint fee, address target);

    /* ----------------------------------------------------------------- */
    string name;
    string symbol;
    uint8 decimals; // many tokens in market use 18 decimals => x * 10 ** 18

    uint256 public override totalSupply;
    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint)) public override allowance;

    /* ----------------------------------------------------------------- */
    event Mint(address indexed minter, uint256 time, uint amount);
    event Burn(address indexed minter, uint256 time, uint amount);

    /* ----------------------------------------------------------------- */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    /* ----------------------------------------------------------------- */
    function _totalSupply() internal virtual view returns (uint){
        return totalSupply;
    }

    function _balanceOf(address account) internal virtual view returns (uint){
        return balanceOf[account];
    }

    function _allowance(address owner, address spender) internal virtual view returns (uint){
        return allowance[owner][spender];
    }

    /* ----------------------------------------------------------------- */
    function theName() external virtual view returns (string memory){
        return name;
    }
    
    function theSymbol() external virtual view returns (string memory){
        return symbol;
    }
    
    function decimal() external virtual view returns (uint8){
        return decimals;
    }

    /* ----------------------------------------------------------------- */
    function _increassAllowance(address owner, address spender, uint amount) internal virtual returns (uint){
        require(amount != type(uint256).max, "overflow can`t accept");
        allowance[owner][spender] += amount; // _allowance(owner, spender) + amount
        uint inc = allowance[owner][spender];
        return inc;
    }
    
    function _decreassAllowance(address owner, address spender, uint amount) internal virtual returns (uint){
        uint256 currentAllowance = _allowance(owner, spender);
        require(currentAllowance >= amount, "decreased allowance below zero");
        unchecked {
            _approve(spender, currentAllowance - amount);
        }
        // allowance[owner][spender] -= amount;
        uint dec = allowance[owner][spender];
        return dec;
    }

    /* ----------------------------------------------------------------- */
    function _approve(address spender, uint amount) internal virtual returns (bool){
        require(msg.sender != address(0), "approve from the zero address!?");
        require(spender != address(0), "approve to the zero address!?");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function _transfer(address recipient, uint amount) internal virtual returns (bool){
        require(recipient != address(0), "transfer recipient can`t be black hole!");
        require(balanceOf[msg.sender] >= amount, "not enught token");
        if(_balanceOf(msg.sender) < amount){
            revert NotTransfer({
                fee: amount, 
                target: recipient
            });
        } else{
            balanceOf[msg.sender] -= amount;
            balanceOf[recipient] += amount;
            emit Transfer(msg.sender, recipient, amount);
            return true;
        }
    }    

    function _transferFrom(address sender, address recipient, uint amount) internal virtual returns (bool){
        require(recipient != address(0), "transfer recipient can`t be black hole!");
        require(balanceOf[msg.sender] >= amount, "not enught token");
        if(_balanceOf(msg.sender) < amount){
            revert NotTransfer({
                fee: amount, 
                target: recipient
            });
        } else{
            _increassAllowance(sender, recipient, amount);
            balanceOf[msg.sender] -= amount;
            balanceOf[recipient] += amount;
            emit Transfer(msg.sender, recipient, amount);
            return true;
        }
    }

    function _tokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0)
        && to != address(0)
        && amount != 0,"Transaction failed, rabbit hole not accepted");
    }

    /* ----------------------------------------------------------------- */
    function approve(address spender, uint amount) external override returns (bool){
        bool success = _approve(spender, amount);
        require(success, "Transaction failed, not approved");
        return success;
    }

    function transfer(address recipient, uint amount) external override returns (bool){
        _tokenTransfer(msg.sender, recipient, amount);
        bool success = _transfer(recipient, amount);
        require(success, "Transaction failed, not transfer");
        return success;
    }

    function transferFrom(address sender, address recipient, uint amount) external override returns (bool){
        _tokenTransfer(sender, recipient, amount);
        bool success = _transferFrom(sender, recipient, amount);
        require(success, "Transaction failed, not transfer");
        return success;
    }

    /* ----------------------------------------------------------------- */
    function _mint(uint amount) internal virtual returns (bool) {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
        return true;
    }

    function _mint(address to, uint amount) internal virtual returns (bool) {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
        return true;
    }

    function _burn(uint amount) internal virtual returns (bool) {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }

    function mint(uint amount) external payable virtual returns (bool success) {
        uint _amount = amount * 10 ** decimals;
        success = _mint(_amount);
        require(success, "Transaction failed");
        emit Mint(msg.sender, block.timestamp, amount);
    }

    function mintTo(address to, uint amount) external payable virtual returns (bool success) {
        _tokenTransfer(msg.sender, to, amount);
        uint _amount = amount * 10 ** decimals;
        success = _mint(to, _amount);
        require(success, "Transaction failed");
        emit Mint(msg.sender, block.timestamp, amount);
    }

    function burn(uint amount) external virtual returns (bool success) {
        success = _burn(amount);
        require(success, "Transaction failed");
        emit Burn(msg.sender, block.timestamp, amount);
    }
}
