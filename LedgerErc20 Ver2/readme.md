# ERC20 LEDGER - ver 2

Do you want *#Ethereum* to act like *#Bitcoin* ?

following the *holders* of erc20 asset. this type of erc20 assets good for *companies, projects and governments*.


### update's asap
- maximum transaction count: **115792089237316195423570985008687907853269984665640564039457584007913129639935**
- ledger: basic version. not track asset's by approved

### functions followed by ledger
- mint [create]
- burn [destroy]
- transfer
- transferFrom

### how to use
```solidity
contract Mock is ERC20 { // ERC20 = ledger.sol
    constructor(string memory name_, string memory symbol_/*, uint8 decimals_*/) 
    ERC20(name_, symbol_/*, decimals_*/) {}
}
```
