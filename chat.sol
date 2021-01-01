pragma solidity ^0.5.11;


contract Messenger {
    
    string public mesage;
    
    Messenger contertulio;
    
     function takeaddresMensajero(Messenger _contract) public {
        contertulio = _contract;
    }
    
     function setmesage(string memory _mesage) public {
         mesage = _mesage;
     }
    
     function getmessagel() view public returns(string memory) {
        return contertulio.mesage();
    }
    
   

}