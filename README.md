# ERC20 Token Contract

This contract contains a basic implementation of an ERC20 token contract in Solidity. The purpose of this contract is to create a custom token with basic functionalities like transferring tokens, checking balances, and approving allowances.

## Features

- **Name and Symbol**: The token has a name and symbol.
- **Decimals**: The token supports up to 18 decimal places for transactions.
- **Total Supply**: The total supply is fixed and assigned to the deployer's address at the time of deployment.
- **Basic ERC20 Functions**:
  - Transfer tokens to another address.
  - Check token balances.
  - Approve and transfer tokens on behalf of other addresses.

---

## How It Works

### 1. **Constructor**
When the contract is deployed:
- The token name, symbol, and decimals are set.
- The total supply is calculated and assigned to the deployer.

### 2. **Functions**
- `name()`: Returns the token name.
- `symbol()`: Returns the token symbol.
- `decimals()`: Returns the number of decimal places.
- `totalSupply()`: Returns the total number of tokens.
- `balanceOf(address)`: Checks the balance of a specific address.
- `transfer(address, amount)`: Transfers tokens to another address.
- `approve(address, amount)`: Approves an allowance for a spender.
- `transferFrom(address, address, amount)`: Allows a spender to transfer tokens on behalf of another address.
- `allowance(address, address)`: Checks the remaining allowance for a spender.

---

## Example Deployment

When deploying this contract:
1. The total supply is set to `1000 * 10^18` tokens.
2. The deployer receives all tokens.
3. The deployer can then transfer tokens to other addresses or allow others to use their tokens.

---

## Events

- **Transfer**: Emitted whenever tokens are transferred from one address to another.
- **Approval**: Emitted whenever an address approves an allowance for a spender.



