# ERC20 
## from scratch

### IERC20:
talk between erc20`s by using [EIP20](https://eips.ethereum.org/EIPS/eip-20) -> [IERC20](https://github.com/mosi-sol/erc20/blob/main/IERC20.sol)

## how to use:
import this contract like following codes:
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "https://github.com/mosi-sol/erc20/tree/main/from%20scratch/ERC20.sol";

contract TheErc20 is ERC20 {
  constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol, _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
}
```

### Functions:

1- exacutable
- approve
- transfer
- transferFrom
- mint
- burn

2- readonly
- totalSupply
- maxSupply
- maxProvider
- balanceOf
- allowance

3- features
- toggleMaxProvider
- setMaxSupply
- event mint
- event burn

