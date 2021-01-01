pragma solidity ^0.5.0;

contract WithdrawalContract {
    
    address public richest;
    uint public mostSent;
    uint public amount ;
    uint public players;
    
    constructor() public {
        players =0;
    }


    function becomeRichest() public payable returns (bool) {
        if (msg.value > mostSent) {
            richest = msg.sender;
            mostSent = msg.value;
            amount += msg.value;
            players++;
            return true;
        } else {
            amount += msg.value;
            players++;
            return false;
        }
    }

    function withdraw() public returns(string memory) {
        require(players >=4);
        if (msg.sender == richest) {
        // Remember to zero the pending refund before
        // sending to prevent re-entrancy attacks
        msg.sender.transfer(amount);
        amount = 0;
        richest = address(0);
        mostSent = 0;
        selfdestruct(msg.sender);
        
    } else {
        return "No eres el mas rico";
        
    }
}

}