pragma solidity ^0.5.11;

contract Ruleta {
    address  owner;
    mapping(address => uint) public playermoney;
    mapping(address => uint) public playernumber;
    mapping(address => uint) public playerbilt;
    uint public time;
    uint public number;
    bool public pasa = false;
    
    constructor()  public payable {
        owner = msg.sender;
        uint zerorone = flip();
        if (zerorone == 1) {
            pasa = true;
        }
            isPassorFalt();
        
        
    }
    
    function flip() view public  returns(uint) {
        return block.timestamp % 2;
    }
    
     function getbalance() view public returns(uint) {
        return address(this).balance;
    }
    
    
    function bynaryCalculator()  internal {
        
        uint zerorone = flip();
        numberCalculator(time, zerorone);
        
        
        
        
    }
    
    function numberCalculator(uint _time, uint _zerorone) internal {
        
        if (_time ==0 && _zerorone==1) {
            number += 1;
        } else if (_time ==1 && _zerorone==1) {
            number += 2;
        }else if (_time ==2 && _zerorone==1) {
            number += 4;
        }else if (_time ==3 && _zerorone==1) {
            number += 8;
        }
        
        time++;
    

    }
    
    function Player(uint _bill, uint _number) public payable {
        require(time < 4);
        playermoney[msg.sender] = msg.value;
        playernumber[msg.sender] =_number;
        playerbilt[msg.sender] =_bill;
        bynaryCalculator();
        
        
    }
    
    function isPassorFalt() internal {
               if (pasa) {
            number+= 18;
        }
    }
    
    function checkingGame() view public returns(string memory) {
        require(msg.sender == owner);
        if (time >= 4) {
        return "No mas apuestas, comprueben si han ganado....";
        } else {
            return "Hagan sus apuestas...";
        }
        
    }
    
    function checkBild()   public returns(string memory, uint) {
        
        if (playernumber[msg.sender] == number) {
             msg.sender.transfer(playermoney[msg.sender] * playerbilt[msg.sender]);
             uint amount = playermoney[msg.sender] * playerbilt[msg.sender];
             return ("Has ganado!!! ", amount);
        } else {
            return   ("Su apuesta no ha sido ganadora. Lo sentimos", 0);
        
        }
        
    }
        

}