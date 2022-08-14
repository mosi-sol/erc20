// SPDX-License-Identifier: MIT
pragma solidity 0.8;

import "./Ledger.sol";

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
