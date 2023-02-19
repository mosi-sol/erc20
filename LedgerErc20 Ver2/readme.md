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

---

## contract info

|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **ERC20** | Implementation | IERC20, IERC20Metadata, ILedger |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | name | External ❗️ |   |NO❗️ |
| └ | symbol | External ❗️ |   |NO❗️ |
| └ | decimals | External ❗️ |   |NO❗️ |
| └ | totalSupply | External ❗️ |   |NO❗️ |
| └ | balanceOf | External ❗️ |   |NO❗️ |
| └ | allowance | External ❗️ |   |NO❗️ |
| └ | approve | External ❗️ | 🛑  |NO❗️ |
| └ | transfer | External ❗️ | 🛑  |NO❗️ |
| └ | transferFrom | External ❗️ | 🛑  |NO❗️ |
| └ | _approve | Internal 🔒 | 🛑  | |
| └ | _transfer | Internal 🔒 | 🛑  | |
| └ | _transfer | Internal 🔒 | 🛑  | |
| └ | incressAllowance | External ❗️ | 🛑  |NO❗️ |
| └ | decressAllowance | External ❗️ | 🛑  |NO❗️ |
| └ | _incressAllowance | Internal 🔒 | 🛑  | |
| └ | _decressAllowance | Internal 🔒 | 🛑  | |
| └ | _mint | Internal 🔒 | 🛑  | |
| └ | _burn | Internal 🔒 | 🛑  | |
| └ | _compressData | Internal 🔒 | 🛑  | |
| └ | _compressData | Internal 🔒 | 🛑  | |
| └ | getData | External ❗️ |   |NO❗️ |
| └ | getResult | External ❗️ |   |NO❗️ |
||||||
| **AuctionNFT** | Implementation | Ownable, ReentrancyGuard |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | startAuction | External ❗️ | 🛑  | onlyOwner |
| └ | bid | External ❗️ |  💵 |NO❗️ |
| └ | end | External ❗️ | 🛑  | onlyOwner |
| └ | _startAuction | Internal 🔒 | 🛑  | |
| └ | _bid | Internal 🔒 | 🛑  | |
| └ | _end | Internal 🔒 | 🛑  | |
| └ | withdraw | External ❗️ | 🛑  | nonReentrant |
| └ | onERC721Received | Public ❗️ | 🛑  |NO❗️ |
||||||
| **StakingRewards** | Implementation |  |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | rewardPerToken | Public ❗️ |   |NO❗️ |
| └ | earned | Public ❗️ |   |NO❗️ |
| └ | stake | External ❗️ | 🛑  | updateReward |
| └ | withdraw | External ❗️ | 🛑  | updateReward |
| └ | getReward | External ❗️ | 🛑  | updateReward |
||||||
| **IERC20** | Interface |  |||
| └ | totalSupply | External ❗️ |   |NO❗️ |
| └ | balanceOf | External ❗️ |   |NO❗️ |
| └ | transfer | External ❗️ | 🛑  |NO❗️ |
| └ | allowance | External ❗️ |   |NO❗️ |
| └ | approve | External ❗️ | 🛑  |NO❗️ |
| └ | transferFrom | External ❗️ | 🛑  |NO❗️ |
||||||
| **IERC721** | Interface |  |||
| └ | balanceOf | External ❗️ |   |NO❗️ |
| └ | ownerOf | External ❗️ |   |NO❗️ |
| └ | safeTransferFrom | External ❗️ |  💵 |NO❗️ |
| └ | safeTransferFrom | External ❗️ |  💵 |NO❗️ |
| └ | transferFrom | External ❗️ |  💵 |NO❗️ |
| └ | approve | External ❗️ |  💵 |NO❗️ |
| └ | setApprovalForAll | External ❗️ | 🛑  |NO❗️ |
| └ | getApproved | External ❗️ |   |NO❗️ |
| └ | isApprovedForAll | External ❗️ |   |NO❗️ |
||||||
| **IERC165** | Interface |  |||
| └ | supportsInterface | External ❗️ |   |NO❗️ |
||||||
| **IERC721TokenReceiver** | Interface |  |||
| └ | onERC721Received | External ❗️ | 🛑  |NO❗️ |
||||||
| **IERC721Metadata** | Interface |  |||
| └ | name | External ❗️ |   |NO❗️ |
| └ | symbol | External ❗️ |   |NO❗️ |
| └ | tokenURI | External ❗️ |   |NO❗️ |
||||||
| **IERC721Enumerable** | Interface |  |||
| └ | totalSupply | External ❗️ |   |NO❗️ |
| └ | tokenByIndex | External ❗️ |   |NO❗️ |
| └ | tokenOfOwnerByIndex | External ❗️ |   |NO❗️ |
||||||
| **ICO** | Implementation | Ownable |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | <Receive Ether> | External ❗️ |  💵 |NO❗️ |
| └ | release | Public ❗️ | 🛑  | onlyOwner |
| └ | setValue | Public ❗️ | 🛑  | onlyOwner |
| └ | claim | Public ❗️ |  💵 |NO❗️ |
| └ | targetIco | Public ❗️ | 🛑  | onlyOwner |
| └ | viewHolders | Public ❗️ |   |NO❗️ |
| └ | wd | Private 🔐 | 🛑  | |
||||||
| **BlockchainSimulation** | Implementation |  |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | <Receive Ether> | External ❗️ |  💵 |NO❗️ |
| └ | _genesis | Internal 🔒 |   | |
| └ | getFee | Public ❗️ |   |NO❗️ |
| └ | getGenesis | Public ❗️ |   |NO❗️ |
| └ | getBlock | Public ❗️ |   |NO❗️ |
| └ | getOwnerById | Public ❗️ |   |NO❗️ |
| └ | getOwnerByAddress | Public ❗️ |   |NO❗️ |
| └ | _generate | Internal 🔒 | 🛑  | |
| └ | WD | Internal 🔒 | 🛑  | |
| └ | starting | Public ❗️ | 🛑  | onlyAdmin |
| └ | setFee | Public ❗️ | 🛑  | onlyAdmin |
| └ | claim | Public ❗️ |  💵 | isStart |
||||||
| **CheckBlock** | Implementation |  |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | gen | Public ❗️ | 🛑  |NO❗️ |
| └ | _gen | Private 🔐 |   | |
| └ | review | Public ❗️ |   |NO❗️ |
| └ | check | Public ❗️ |   |NO❗️ |


 Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |

## signature hash

| Sighash   |   Function Signature | 
| ---- | ---- |
| 06fdde03  |  name() | 
| 95d89b41  |  symbol() | 
| 313ce567  |  decimals() | 
| 18160ddd  |  totalSupply() | 
| 70a08231  |  balanceOf(address) | 
| dd62ed3e  |  allowance(address,address) | 
| 095ea7b3  |  approve(address,uint256) | 
| a9059cbb  |  transfer(address,uint256) | 
| 23b872dd  |  transferFrom(address,address,uint256) | 
| 7b7d7225  |  _approve(address,uint256) | 
| 4847a79c  |  _transfer(address,uint256) | 
| 30e0789e  |  _transfer(address,address,uint256) | 
| 824fcccb  |  incressAllowance(address,uint256) | 
| 0af88d05  |  decressAllowance(address,uint256) | 
| c1e37b77  |  _incressAllowance(address,uint256) | 
| f3bb3806  |  _decressAllowance(address,uint256) | 
| 4e6ec247  |  _mint(address,uint256) | 
| 6161eb18  |  _burn(address,uint256) | 
| 7ec5cf87  |  _compressData(uint256,address) | 
| ca3f9df2  |  _compressData(uint256,address,address) | 
| 0178fe3f  |  getData(uint256) | 
| 995e4339  |  getResult(uint256) | 
