// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// simple swap extention
import "https://github.com/mosi-sol/erc20/blob/main/IERC20.sol";

contract TokenSwap {
    IERC20 public pairTokenA;
    IERC20 public pairTokenB;
    address public traderA;
    address public traderB;
    uint public pairValueA;
    uint public pairValueB;

    constructor(
        address _pairTokenA,
        address _traderA,
        address _pairTokenB,
        address _traderB,
        uint _pairValueA,
        uint _pairValueB
    ) {
        pairTokenA = IERC20(_pairTokenA);
        pairTokenB = IERC20(_pairTokenB);
        traderA = _traderA;
        traderB = _traderB;
        pairValueA = _pairValueA;
        pairValueB = _pairValueB;
    }

    function swap() public {
        require(msg.sender == traderA || msg.sender == traderB, "Not authorized");
        require(
            pairTokenA.allowance(traderA, address(this)) >= pairValueA,
            "Token A allowance too low"
        );
        require(
            pairTokenB.allowance(traderB, address(this)) >= pairValueB,
            "Token B allowance too low"
        );

        _safeTransferFrom(pairTokenA, traderA, traderB, pairValueA);
        _safeTransferFrom(pairTokenB, traderB, traderA, pairValueB);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}
