
pragma solidity >=0.8.2 <0.9.0;

contract Token {

    // variables
    string public name = "Indulgences";
    string public symbol = "IND";
    uint8 public decimals = 18;
    uint256 public totalSupply = 0;

    //more complex data type, that says "given all the addresses, prepare to create a uint256 in the balances"
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances [_owner];
    }

    //mint dispenses tokens from nowhere
    function mint(address _owner) public {
        balances [_owner] += 10;
        totalSupply += 10;
        emit Transfer( address(0), _owner, 10);
    }

    //transfer takes the tokens from somewhere
    function transfer(address _to, uint256 _value) public returns (bool success) {
        //require(balances[msg.sender] >= _value, "Not enough tokens in balance");
        if( balances [msg.sender] <= _value ) {
            return false;
        }

        balances [msg.sender] -= _value;
        balances [_to] += _value;
        emit Transfer( msg.sender, _to, _value);
        return true;
    }

    //this verifies that the sender has enough money. This confirmation happens between the two parties: sender and receiver
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require (balances [_from] >= _value, "sorry, not enough tokens");
        require (allowances [_from] [msg.sender] >= _value, "anauthorized transfer");
        allowances [_from] [msg.sender] -= _value;
        balances [_from] -= _value;
        balances [_to] += _value;
        emit Transfer( msg.sender, _to, _value);
        return true;
    }

    //this checks that the senders account has the "allowance" to send the tokens. 
    //This is a third party confirmation. In order for this to happen, it adds the equivalent of the value to the sender's allowance
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances [msg.sender] [_spender] += _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances [_owner] [_spender];
    }

 }
