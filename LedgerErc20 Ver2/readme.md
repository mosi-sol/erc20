# ERC20 LEDGER - ver 2

Do you want *#Ethereum* to act like *#Bitcoin* ?

following the *holders* of erc20 asset. this type of erc20 assets good for *companies, projects and governments*.

### Live demo
- Ledger Erc20 Mock [Live on BSC testnet](https://testnet.bscscan.com/address/0x9ddee794ae455eb10043c2af1bc24ee5ccc0dffc) 
- Ledger Coin [Live on LUKSO 16](https://explorer.execution.l16.lukso.network/address/0x0F1FB152945d5e9bb7B0841D3a6981f22428C7c3/contracts) 
- ledger id's from 0 to 3 for test, use function `getResult` for view data

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

***enjoy it!***

---

## Ledger complete code:

```solidity

// ========== ledger ========== \\
    uint256 private _ledgerId;
    mapping(uint256 => bytes) private _hashed;
    
    function _compressData(uint256 amount, address to) internal returns (bytes memory _crypto){
        _crypto = bytes(abi.encode(_ledgerId, msg.sender, to, amount, block.timestamp));
        _hashed[_ledgerId] = _crypto;
        emit MintData(_ledgerId, block.timestamp, _crypto);
        _ledgerId += 1;
    }

    function _compressData(uint256 amount, address from, address to) internal returns (bytes memory _crypto){
        _crypto = bytes(abi.encode(_ledgerId, from, to, amount, block.timestamp));
        _hashed[_ledgerId] = _crypto;
        emit MintData(_ledgerId, block.timestamp, _crypto);
        _ledgerId += 1;
    }

    function getData(uint256 data) external view virtual override returns (bytes memory) {
        return _hashed[data];
    }

    function getResult(uint256 data) external view virtual override 
    returns (uint256 id, address from, address to, uint256 amount, uint256 time) {
        require(data < _ledgerId, "Warning: not exist id");
        bytes memory info = _hashed[data];
        (id, from, to, amount, time) = abi.decode(info, (uint256, address, address, uint256, uint256));
    }
```

### for find latest ledger id, use this code:
```solidity
function currentLedgerId() external view returns (uint256) {
    return _ledgerId;
}
```
### alert
deep in code and find DS...
