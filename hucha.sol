
// SPDX-License-Identifier: MIT

// https://spdx.org/licenses/
pragma solidity ^0.8.0;

contract Hucha {
    
    address owner;
    mapping(address => bool) debtor;
    mapping(uint => uint) check; 

    /**
   * Event for operations
   * @param msg message of operation
   * @param amount of operation
   */
    event operations(string msg, uint amount);
    
    
    
    modifier segurity {
        require(msg.sender == owner);
        _;
    }
    
    constructor()  {
        owner = msg.sender; 
    }
    
    
    function getbalance() view public returns(uint) {
        return address(this).balance;
    }
    
    function enterFunds(uint amount) public payable {
        require(msg.value == amount);
        emit operations("Ingreso realizado de: ", amount);

              
    }
    
     function extractFunds(uint amount) segurity public {
              payable(msg.sender).transfer(amount);
              emit operations("Se han sacado: ", amount);
              
    }
    
    function kill() segurity public {
        selfdestruct(payable(msg.sender));
    } 
    
   

function paycheck(uint _check) public {
        require(debtor[msg.sender], "Usted no es el propietario de este cheque");
        require(check[_check] != 0, "Este cheque no existe"); // si no existe el cheque devolvera cero. 
        payable(msg.sender).transfer(check[_check]);
        debtor[msg.sender] = false;
        
    }
    
    function setdebtor(address _address, uint _checkId, uint256  _amount) segurity public {
        check[_checkId] = _amount;
        debtor[_address] = true;
        
    }
    
}
