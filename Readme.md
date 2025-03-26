# Documentation of ERC20 Token

## Introduction

The first part of this contract is an interface taken from OpenZeppelin. OpenZeppelin provides secure and tested implementations of ERC20 standards, making it easier to work with Ethereum tokens without writing everything from scratch. 

Using this interface ensures that our token follows the ERC20 standard, which helps in compatibility with wallets, exchanges, and other blockchain applications.

Below this section, I have written my custom contract, where I have inherited the ERC20 interface to create my own token with additional features.

## Functions

### balanceOf Function
This function allows users to check the balance of any address. It takes an address as input and returns the number of tokens held by that address.

**How it works:**
- The function looks up the balance stored in the `balanceOfUser` mapping.
    mapping(address => uint) public balanceOfUser;
- It returns the balance of the given address.
- This function is `external` and `view`, meaning it can only be called from outside the contract and does not modify any data.

### transfer Function
This function allows users to send tokens from their own account to another account.

**How it works:**
- It checks if the sender is blacklisted or their account is frozen.
- It ensures that the recipient address is valid.
- It verifies that the sender has enough balance to transfer the requested amount.
- If all checks pass, it deducts the tokens from the sender’s balance and adds them to the recipient’s balance.
- Finally, it emits a `Transfer` event. event Transfer(address indexed from, address indexed to, uint256 value);

### allowance Function
This function allows users to check how many tokens a spender is allowed to use from an owner’s account.

**How it works:**
- It returns the amount of tokens the owner has approved for a spender.
- This function is `external` and `view`, meaning it does not modify any data.

### approve Function
This function allows an owner to approve a spender to use a certain amount of their tokens.

**How it works:**
- It checks if the spender’s address is valid.
- It verifies that the owner has enough balance to approve the specified amount.
- If all checks pass, it updates the allowance and emits an `Approval` event.  event Approval(address indexed owner, address indexed spender, uint256 value);

### transferFrom Function
This function allows an approved spender to transfer tokens on behalf of the owner.

**How it works:**
- It checks if the sender or recipient is blacklisted or has a frozen account.
- It ensures that the sender has sufficient balance and allowance.
- It deducts the amount from both the sender’s balance and allowance, and then adds it to the recipient’s balance.
- A `Transfer` event is emitted.

### mint Function
This function allows the contract owner to create new tokens and assign them to a specified address.

**How it works:**
- Only the contract owner can call this function.
- It increases the total supply of tokens.
- It adds the new tokens to the recipient’s balance.
- A `Transfer` event is emitted from the zero address to the recipient.

### burn Function
This function allows users to permanently remove tokens from circulation.

**How it works:**
- It verifies that the caller has enough balance to burn the specified amount.
- It deducts the tokens from the caller’s balance and decreases the total supply.
- A `Transfer` event is emitted to indicate the burn.

### freezeAccount Function
This function allows the owner to freeze a user’s account, preventing them from making transactions.

**How it works:**
- The owner specifies an address to freeze.
- The account’s status is updated to `true` in the `frozenAccounts` mapping.
- A `AccountFrozen` event is emitted.

### unfreezeAccount Function
This function allows the owner to unfreeze a previously frozen account.

**How it works:**
- The owner specifies an address to unfreeze.
- The account’s status is updated to `false` in the `frozenAccounts` mapping.
- A `AccountFrozen` event is emitted.

### pause Function
This function allows the owner to pause all token transactions in case of an emergency.

**How it works:**
- It ensures that the contract is not already paused.
- If not paused, it updates the `paused` status to `true`.
- A `Paused` event is emitted.

### unpause Function
This function allows the owner to resume token transactions if they were previously paused.

**How it works:**
- It ensures that the contract is currently paused.
- If paused, it updates the `paused` status to `false`.
- An `Unpaused` event is emitted.

### blacklist Function
This function allows the owner to mark an address as blacklisted, preventing it from sending or receiving tokens.

**How it works:**
- The owner specifies an address to blacklist.
- The account’s status is updated to `true` in the `isBlackListed` mapping.
- A `BlackListed` event is emitted.

### unblacklist Function
This function allows the owner to remove an address from the blacklist, allowing it to send and receive tokens again.

**How it works:**
- The owner specifies an address to unblacklist.
- The account’s status is updated to `false` in the `isBlackListed` mapping.
- A `BlackListed` event is emitted.

### transferOwnership Function
This function allows the owner to transfer ownership of the contract to another address.

**How it works:**
- It ensures that the new owner’s address is valid.
- It updates the contract’s `Founder` variable to the new owner.
- An `OwnershipTransferred` event is emitted, recording the change.

