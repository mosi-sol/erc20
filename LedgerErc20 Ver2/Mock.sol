// SPDX-License-Identifier: MIT
pragma solidity 0.8;

import "./Ledger.sol";

/*====================
test by: mock example
====================*/

contract Mock is ERC20 {
    constructor(string memory name_, string memory symbol_/*, uint8 decimals_*/) 
    ERC20(name_, symbol_/*, decimals_*/) {
        testMint();
    }

    function testMint() public {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }

    function testBurn() public {
        _burn(msg.sender, 500 * 10 ** 18);
    }

    function testTransfer(address recipient) public {
        _transfer(recipient, 150 * 10 ** 18);
    }

    function testTransferFrom(address recipient) public {
        _transfer(msg.sender, recipient, 1000 * 10 ** 18);
    }

    function testApprove(address recipient) public {
        _approve(recipient, 50 * 10 ** 18);
    }
}
