// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;
abstract contract Erc20_interface{
    //functions
    function name() public view virtual  returns (string memory);
    function symbol() public view virtual returns (string memory);
    function decimals() public view virtual returns (uint8);
    function totalSupply() public view virtual returns (uint256);
    function balanceOf(address _owner) public view virtual  returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual  returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public virtual  view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


    }
contract tokencreation is Erc20_interface {
    string public _name;
    string public _symbol;
    uint8 public _decimals;
    uint256 public _totalsupply;

    mapping (address => uint) balances;
    mapping (address =>  mapping (address => uint)) allowances;

    constructor(){
        _name = "myfirsttoken";
        _symbol = "token";
        _decimals = 18;
        _totalsupply = 1000 * 10 ** _decimals;
        balances[msg.sender] = _totalsupply;
        emit Transfer(address(0),msg.sender,_totalsupply);

    }
    function name() public view override returns (string memory){
        return _name;
    }
    function symbol() public view override  returns (string memory){
        return _symbol;
    }
    function decimals() public view override returns (uint8){
        return _decimals;
    }
    function totalSupply() public view override  returns (uint256){
        return _totalsupply;
    }
    function balanceOf(address _owner) public view override returns (uint256 balance){
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) public override  returns (bool success){
        transferFrom(msg.sender,_to,_value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public override  returns (bool success){
        require(balances[_from] >= _value);
        balances[_from] -= _value;
        balances[_to]   += _value;
        allowances[_from][msg.sender] -= _value;
        emit Transfer(_from,_to,_value);
        return true;
    }
    function approve(address _spender, uint256 _value) public override returns (bool success){
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) public override view returns (uint256 remaining){
        return allowances[_owner][_spender];
    }
}
