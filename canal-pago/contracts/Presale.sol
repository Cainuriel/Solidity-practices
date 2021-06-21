
//SPDX-License-Identifier: Unlicense

pragma solidity ^0.6.12;

import  "./Crowdsale.sol";
import  "./tools/Ownable.sol";
//import  "@openzeppelin/contracts/crowdsale/Crowdsale.sol";
//import  "@openzeppelin/contracts/token/ERC20/Ownable.sol";
//import "hardhat/console.sol";

/**
 * Standard de preventa con algunas customizacinones personales.
 *
 *endsold: para la preventa y envia los tokens que no se hayan vendido
 *al propietario
 *TokenBalance: Indica la cantidad de tokens que hay en el contrato
*
 Setrate: Se puede cambiar la cantidad de tokens a enviar por 1 BNB cuando queramos.
 *\
 */


interface TokenInterface {
    // determinamos las funciones que necesitamos del ERC20. Tienen que ser iguales.
    function decimals() external view  returns(uint8);
    function balanceOf(address _address) external view returns(uint256);
    function transfer(address _to, uint256 _value) external returns (bool success);
}



contract Presale is Crowdsale, Ownable {
    
     TokenInterface TokenContract; // interface para manipular metodos del token.

    // tanto _token como _addresstoken son la misma direccion. La diferencia esta en su uso.
    // al ser un lenguaje tipado, debemos pasarlo como contrato y como direccion para 
    // hacer operaciones diferentes.
    constructor  (uint256 _rate, 
    address payable _wallet, 
    BEP20 _token,
    address _addressToken
    ) 
    Crowdsale(_rate,  _wallet, _token) 
    
    public {
        
        // pásamos el contrato del token, como direccion para ser usada por la interface
        TokenContract = TokenInterface(_addressToken);
        //console.log("Desplegado contrato de venta de los tokens del contrato: ", _token);
        
        
    }
    
     // Funcion que liquida el contrato para que no se pueda vender mas.
    function endSold() public  onlyOwner() {
        
        // compensacion de saldos. 
        require(TokenContract.transfer(owner(), TokenContract.balanceOf(address(this))));
        msg.sender.transfer(address(this).balance);
       
    }
    
       function TokenBalance() public view returns (uint256)  {
    return TokenContract.balanceOf(address(this));
  }
  
     function setRate(uint256 _newrate) public onlyOwner() {
    rate = _newrate;
  }
  
  
}