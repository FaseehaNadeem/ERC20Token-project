// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
// take this interface from openzeppelin
interface ERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract MyToken is ERC20 {
    string public name = "My Token";
    string public symbol = "MT";
    uint8 public decimals = 18;
    uint public totalSupply = 100000000;
    address public Founder;

    constructor() {
        Founder = msg.sender;
        balanceOfUser[Founder] = totalSupply;
    }

    mapping(address => uint) public balanceOfUser;
    mapping(address => mapping(address => uint)) public allowTokens;
    mapping(address => bool) public frozenAccounts;
    mapping(address => bool) public isBlackListed;
    
    // to check the balance of an address 
    function balanceOf(address account) external view returns (uint256) {
        return balanceOfUser[account];
    }
    
    // TO SEND TOKENS DIRECTLY FROM ONE TO ANOTHER  
    function transfer(address to, uint256 value) external whenNotPaused returns (bool) {
        require(!isBlackListed[msg.sender], "You cannot make any transaction");
        require(!isBlackListed[to], "You cannot make any transaction");
        require(!frozenAccounts[msg.sender], "Your account is frozen!");
        require(!frozenAccounts[to], "Recipient account is frozen!");
        require(to != address(0), "Invalid Address");
        require(balanceOfUser[msg.sender] >= value, "Not Enough Balance");

        balanceOfUser[msg.sender] -= value;
        balanceOfUser[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    // owner allow the spender to spend his token
    // this function checks that how many token approval did owner give to the spender
    // check allowance
    function allowance(address owner, address spender) external view returns (uint256) {
        return allowTokens[owner][spender];
    }

    // set allowance
    // owner allow any spender to use tokens to a specific amount
    function approve(address spender, uint256 value) external returns (bool) {
        require(spender != address(0), "Invalid Address");
        require(balanceOfUser[msg.sender] >= value, "Not Enough Balance");
        allowTokens[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    // this function allow the spender to user owner token on his behalf
    function transferFrom(address from, address to, uint256 value) external whenNotPaused returns (bool) {
        require(!frozenAccounts[from], "Sender account is frozen!");
        require(!frozenAccounts[to], "Recipient account is frozen!");
        require(!isBlackListed[from], "Sender is blacklisted");
        require(!isBlackListed[to], "Recipient is blacklisted");
        require(to != address(0), "Invalid address");
        require(from != address(0), "Invalid address");
        require(balanceOfUser[from] >= value, "Not Enough Balance");
        require(allowTokens[from][msg.sender] >= value, "Allowance exceeded");
        allowTokens[from][msg.sender] -= value;
        balanceOfUser[from] -= value;
        balanceOfUser[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    modifier onlyowner() {
        require(msg.sender == Founder, "Unauthorized");
        _;
    }

    // only the owner mint the new token 
    function mint(address to, uint256 amount) external onlyowner {
        require(amount > 0, "Invalid Amount");
        totalSupply += amount;
        balanceOfUser[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    // anyone burn thier token
    function burn(uint256 amount) external {
        require(balanceOfUser[msg.sender] >= amount, "Not enough Tokens");
        balanceOfUser[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    // freeze the account of any user so he can't do transactions in the mean time
    event AccountFrozen(address indexed account, bool isFrozen);

    function freezeAccount(address account) external onlyowner {
        require(account != address(0), "Invalid address");
        frozenAccounts[account] = true;
        emit AccountFrozen(account, true);
    }

    // unfreeze the account of any user so he can do transactions again in the mean time
    function unfreezeAccount(address account) external onlyowner {
        require(frozenAccounts[account], "Account is already unfrozen!");
        frozenAccounts[account] = false;
        emit AccountFrozen(account, false);
    }

    bool public paused = false;
    event Paused(address indexed owner);
    event Unpaused(address indexed owner);

    modifier whenNotPaused() {
        require(!paused, "Token transfers are paused");
        _;
    }

     // owner  pause the whole system in case of emergency no  transcations are allowed when contract is paused
    function pause() external onlyowner {
        require(!paused, "Already paused");
        paused = true;
        emit Paused(Founder);
    }

    // unpause the contract 
    function unpause() external onlyowner {
        require(paused, "Already unpaused");
        paused = false;
        emit Unpaused(Founder);
    }

    // blacklist the person then he can't transfer or receive tokens 
    event BlackListed(address indexed account, bool status);

    function blacklist(address account) external onlyowner {
        isBlackListed[account] = true;
        emit BlackListed(account, true);
    }

    // unblacklist the person then he can transfer or receive tokens again
    function unblacklist(address account) external onlyowner {
        isBlackListed[account] = false;
        emit BlackListed(account, false);
    }
    
    // this function sets the new owner 
    event OwnershipTransferred(address indexed previousOwner, address indexed newowner);

    function transferOwnership(address newowner) external onlyowner {
        require(newowner != address(0), "Invalid address");
        address previousOwner = Founder;
        Founder = newowner;
        emit OwnershipTransferred(previousOwner, newowner);
    }
}
