// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Burnable, Pausable, Ownable {
    
    uint256 public price;
    constructor(string memory _name, string memory _symbol, uint256 _price) ERC20(_name, _symbol) {
        price = _price;
        // _mint(msg.sender, 100 * 10 ** uint(decimals()));
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function mint(address to, uint256 amount) public payable { // onlyOwner
        require(msg.value >= price * amount, "need more credit for mint...");
        _mint(to, amount);
    }

    function withdraw() public onlyOwner {

    }

    function walletBalance() public view returns (uint256) {

    }

    receive() external payable {}
    fallback() external payable {}
}

