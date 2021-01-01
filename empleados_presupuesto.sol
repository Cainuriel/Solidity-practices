pragma solidity ^0.5.11;

contract Presupuesto {
    
    address owner;
    address[] employees;
    mapping(string => mapping(address => uint)) sueldos;
    uint public sueldo;
    mapping(address => Employer) team;
    
    struct Employer {
        string name;
        uint sueldo;
        uint saldo;
    }
    
    modifier segurity {
        
        bool ok = false;
        for (uint8 i=0; i < employees.length; i++  ) {
            if (employees[i] == msg.sender) {
                ok = true;
            }
        }
        require(ok);
        _;
    }
    
    constructor(uint presupuesto, uint num) public payable {
        owner = msg.sender;
        require(msg.value == presupuesto);
        sueldo = presupuesto / num;
        }
        
    function setemployees(address _address, string memory _name) public {
        require(msg.sender == owner);
        employees.push(_address);
        team[_address].name = _name;
        team[_address].sueldo = sueldo;
        team[_address].saldo = sueldo;
        
    }
        
    function withdraw() public segurity {
        msg.sender.transfer(sueldo);
        team[msg.sender].saldo -= sueldo;
        
       
        
    }
    
    function getDisponible() view external returns(uint) {
        return team[msg.sender].saldo;
    }
    
    function getbalance() view public returns(uint) {
        return address(this).balance;
    }
    
    
    
}