// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "gambling_interface.sol";

contract cho_han is gambling{
    uint8 die_min = 1;
    uint8 die_faces = 6; 
    uint64 house_edge = 5;
    uint64 public maxBet = 100;
    uint64 public minBet = 1;
   

    //Modifiers:

    modifier betInRange(uint64 value) {
        require(value <= maxBet && value >= minBet);
        _;
    }

    //Main functions
    //roll a single die
    function roll(address seedAddress) public 
    returns (uint number) {
         uint returnedIntegerValue = Irandom(seedAddress).randNumber(die_min, die_faces);
         return  returnedIntegerValue;
    }

    //not fully implemented, returns true on win false on loss.
    function bet(uint64 value, bool betIsEven) validBet(value) betInRange(value) public returns(bool) {
        uint256 die1Value = roll(msg.sender);
        uint256 die2Value = roll(msg.sender);
        bool rollIsEven = false;
        if (die1Value+die2Value % 2 ==  0){
            rollIsEven = true;
        }
        if (rollIsEven == betIsEven){
            return true;
        }
        else{
            return false;
        }
    }
}