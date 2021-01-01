pragma solidity ^0.5.0;

// para evitar el overflow o el underflow necesitamos usar una libreria
// de solidity. el ejemplo usa uint8 que son solo los numeros entre el
// 0 y el 255. Usando la libreria generamos la excepcion necesaria.

import "./SaveMath.sol";


contract Votacion {
    
    using SafeMath for uint8;
    mapping (address => uint8) public usuarios;
    
    function sumarvotos(uint8 voto) public {
        usuarios[msg.sender] = usuarios[msg.sender].add(voto);
    }
    
    
    function restarvotos(uint8 voto) public {
        usuarios[msg.sender] = usuarios[msg.sender].sub(voto);
    }
    
}