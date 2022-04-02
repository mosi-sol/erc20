// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// EIP20 => https://eips.ethereum.org/EIPS/eip-20
import "https://github.com/mosi-sol/erc20/blob/main/IERC20.sol";

contract ERC20 is IERC20 {
    // variables
    string name;
    string symbol;
    uint8 decimals; // many tokens in market use 18 decimals => x * 10 ** 18
    uint256 public totalSupply;
    uint256 public maxSupply;
    bool public maxProvider = false;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    // events implemened from IERC20
    // event Transfer(address indexed from, address indexed to, uint value);
    // event Approval(address indexed owner, address indexed spender, uint value);
    // new events
    event Mint(address indexed miner, uint256 date, uint256 amount);
    event Burn(address indexed burner, uint256 date, uint256 amount);

    // modifier

    // initialize
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    // public functions
    function approve(address spender, uint amount) external returns (bool success) {
        success = _approve(spender, amount);
        require(success, "Transaction failed");
    }

    function transfer(address recipient, uint amount) external returns (bool success) {
        success = _transfer(recipient, amount);
        require(success, "Transaction failed");
    }

    function transferFrom(address sender, address recipient, uint amount) external returns (bool success) {
        success = _transferFrom(sender, recipient, amount);
        require(success, "Transaction failed");
    }

    function mint(uint amount) external returns (bool success) {
        success = _mint(amount);
        require(success, "Transaction failed");
    }

    function burn(uint amount) external returns (bool success) {
        success = _burn(amount);
        require(success, "Transaction failed");
    }

    // terminal logic [only owner]
    function toggleMaxProvider() internal { // onlyOwner function -> this is important
        maxProvider = !maxProvider;
    }

    function setMaxSupply(uint256 _max) internal { // onlyOwner function -> this is important
        maxSupply = _max;
    }

    // logic/internals -> wrapping the logic for more security --> https://github.com/mosi-sol/audit/tree/main/wrappedCondition
    // important: if implement this, use --> virtual override <-- then can use -> super <- keyword for call base
    // read more content here: https://docs.openzeppelin.com/contracts/4.x/extending-contracts#using-hooks

    function _approve(address spender, uint amount) internal virtual returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function _transfer(address recipient, uint amount) internal virtual returns (bool){
        require(recipient != address(0), "transfer recipient cant be black hole!");
        require(balanceOf[msg.sender] >= amount, "not enught token");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function _transferFrom(address sender, address recipient, uint amount) internal virtual returns (bool){
        require(recipient != address(0), "transfer recipient cant be black hole!");
        require(balanceOf[msg.sender] >= amount, "not enught token");
        allowance[sender][msg.sender] -= amount;
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function _mint(uint amount) internal virtual returns (bool) {
        if(maxProvider == true) {
            if(maxSupply > 0 && maxSupply < (totalSupply+amount)) {
                balanceOf[msg.sender] += amount;
                totalSupply += amount;
                emit Transfer(address(0), msg.sender, amount);
                emit Mint(msg.sender, block.timestamp, amount);
                return true;
            }
        } else if(maxProvider == false) {
            balanceOf[msg.sender] += amount;
            totalSupply += amount;
            emit Transfer(address(0), msg.sender, amount);
            emit Mint(msg.sender, block.timestamp, amount);
            return true;
        }
        return false;
    }

    function _burn(uint amount) internal virtual returns (bool) {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
        emit Burn(msg.sender, block.timestamp, amount);
        return true;
    }

}
