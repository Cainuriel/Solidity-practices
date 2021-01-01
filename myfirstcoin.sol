pragma solidity ^0.5.0;

contract MyFirstCoin {
    // creando una variable publica genera automaticamente su getter
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    
    // variables para convertir el token en una acción de dividendos
    
    uint256 dividendforTokens;
    mapping(address => uint256) dividendBalanceOf;
    mapping(address => uint256) dividendCreditTo;
    
    // funcion de actualizacion de dividendos
    function update(address _address) public {
        uint256 debit = dividendforTokens - dividendCreditTo(_address);
        dividendBalanceOf += balanceOf(_address) * debit;
        dividendforTokens(_address) = dividendCreditTo;
    }
    
    // dos funciones para los dividendos
    function withdraw() public {
        update(msg.sender);
        uint256 amount = dividendBalanceOf(msg.sender);
        dividendBalanceOf(msg.sender) = 0;
        msg.sender.transfer(amount);
        
    }

    function deposit() public payable {
        dividendforTokens += msg.value / totalSupply;
    }
    
    // constructor de nuestro token
    constructor() public {
        
        name = "Dementicon";
        symbol = "DMT";
        decimals = 6;
        totalSupply = 1999 * (uint256(10) ** decimals);
        // damos los tokens a la direccion creadora
        balanceOf[msg.sender] = totalSupply;
        
        
        
    }
    
    
    //diccionario que guarda el saldo de tokens para cada direccion
    mapping(address => uint256) public balanceOf;
    
    //diccionario que guarda las direcciones que permitimos manejen nuestros tokens
    mapping(address => mapping(address => uint256)) public allomance;
    
    // indexamos el evento para que se registre mas ordenado
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    
    // funcion que transfiere tokens a una direccion
    function transfer(address _to, uint256 _value) public returns (bool success) {
        
    // lo primero es comprobar que el balance del emisor si es suficiente.
    require(balanceOf[msg.sender] >= _value );
    
    //actualizamos las variables de dividendos
    update(msg.sender);
    update(_to);
    
    // comprobado que tiene saldo, se lo restamos al emisor se lo sumamos al receptor
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    
    // llamamos al evento que registra la transaccion
    emit Transfer(msg.sender,_to,_value);
    return true;
        
    }
    
    // funcion para aprovar a direcciones a usar nuestros tokens.
    function approve(address _spender, uint256 _value) public returns (bool success) {
    allomance[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
        
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value );
        require(allomance[_from][msg.sender] >= _value);
        // Balanceamos las cuentas
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        // autorizamos el derecho sobre nuestros tokens
        allomance[_from][msg.sender] -= _value;
        //registramos la transferencia definitivamente
        emit Transfer(_from, _to, _value);
        return true;
        
    }


    
    
}