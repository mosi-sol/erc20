// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "https://github.com/mosi-sol/erc20/blob/main/IERC20.sol";

contract EasyErc20 is IERC20 {
    string public constant name = "Easy Erc20 Token";
    string public constant symbol = "EET";
    uint8 public constant decimals = 18;
    
    uint private _totalSupply;
    mapping (address => uint) private _balanceOf;
    mapping (address => mapping (address => uint)) private _allowances;
    
    constructor() {
        _totalSupply = 1000 * 10 ** decimals;
        _balanceOf[msg.sender] = _totalSupply;
    }
    
    function totalSupply() public view returns (uint _totalSupply_) {
        _totalSupply_ = _totalSupply;
    }
    
    function balanceOf(address _addr) public view returns (uint balance) {
        return _balanceOf[_addr];
    }
    
    function transfer(address _to, uint _value) public returns (bool success) {
        if (_value > 0 && _value <= balanceOf(msg.sender)) {
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value;
            return true;
        }
        return false;
    }
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        if (_value > 0 && _value <= _balanceOf[_from]) {
            _allowances[_from][_to] += _value;
            _balanceOf[_from] -= _value;
            _balanceOf[_to] += _value;
            return true;
        }
        return false;
    }
    
    function approve(address _spender, uint _value) public returns (bool success) {
        _allowances[msg.sender][_spender] = _value;
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return _allowances[_owner][_spender];
    }
}
