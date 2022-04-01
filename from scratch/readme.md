# ERC20 
## from scratch

### IERC20:
talk between erc20`s by using [EIP20](https://eips.ethereum.org/EIPS/eip-20) -> [IERC20](https://github.com/mosi-sol/erc20/blob/main/IERC20.sol)

## how to use:
import this contract like following codes, & use costructor:
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "https://github.com/mosi-sol/erc20/blob/main/from%20scratch/ERC20.sol";

contract TheErc20 is ERC20 {
  constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20 (_name, _symbol, _decimals) {
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

#

## use internal logic functions

### hook avalible
```
function _functionName(arguments) internal virtual returns (bool){
  super._functionName(x);
}
```
***more info about hook:*** ` https://docs.openzeppelin.com/contracts/4.x/extending-contracts#using-hooks `

#

### example:
[example](https://github.com/mosi-sol/erc20/blob/main/from%20scratch/flatERC20Example.sol)

deploy : ` TokenERC20.sol `

---
<p align="right"> 
  <a href="https://github.com/mosi-sol/erc20/blob/main/from%20scratch/ERC20.sol" target="blank">
  <img src="https://img.shields.io/badge/from%20scratch-ERC20-blue?style=flat" alt="cafe_pafe" /></a> 
  <a href="https://github.com/mosi-sol/erc20" target="blank">
  <img src="https://img.shields.io/github/license/mosi-sol/erc20" alt="pafecafe" /></a> 
</p>
