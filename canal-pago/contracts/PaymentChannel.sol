
//SPDX-License-Identifier: Unlicense

pragma solidity ^0.6.12;

contract PaymentChannel {

    address owner;
    mapping(uint256 => bool) usedNonces; // numero de serie de los cheques de pago.

    constructor() public payable {
    owner = msg.sender;
    }

    // funcion que ingresa dinero en el contrato
    function moreMoney() public payable {
        require(msg.sender == owner);
    }

    function claimPayment(uint256 _amount, uint256 _nonce, bytes memory _sig) public {

        // comprobar si ya se ha pagado.
        require(!usedNonces[_nonce], 'Este cheque ya se ha pagado');


        //hash del pago
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, _amount, _nonce, address(this)));
        // Es buena practica hacer lo siguiente. Busca info en google para saber porque.
        hash = keccak256(abi.encodePacked("\x19Ethereunm Signed Message:\n32", hash));

        // Comprueba quien firmó el hash, que ha de ser el owner.
        require(recoverSigner(hash, _sig) == owner);

        msg.sender.transfer(_amount);
        usedNonces[_nonce] = true;

    }

        // genera las tres variables de la firma de 32 bytes.
       function splitSignature(bytes memory _sig) internal pure returns(uint8, bytes32, bytes32){

           require(_sig.length == 65);

           bytes32 r;
           bytes32 s;
           uint8 v;

            // lenguaje ensamblador de solidity
           assembly {

               r := mload(add(_sig, 32))
               s := mload(add(_sig, 64))
               v := byte(0,  mload(add(_sig, 96)))

           }

           return (v, r, s);

        }


        function recoverSigner(bytes32 _hash, bytes memory _sig) internal pure 
        returns(address) {

            bytes32 r;
           bytes32 s;
           uint8 v;

           (v, r, s) = splitSignature(_sig);

            // funcion que firma el hash.
            /**
            @return la clave publica de quien firmo el hash
             */
           return ecrecover(_hash, v, r, s);

        }
}