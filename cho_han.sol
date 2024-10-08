// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "gambling_interface.sol";

contract cho_han is gambling{
    uint8 die_min = 1;
    uint8 die_faces = 6; 
    uint64 house_edge = 500; //house edge in basis points (500 = 5%)
    uint64 public maxBet = 1000000;
    uint64 public minBet = 1000;
   

    //Modifiers:

    modifier betInRange(uint64 value) {
        require(value <= maxBet && value >= minBet);
        _;
    }

    //Main functions
    //roll a single die
    function roll() public 
    returns (uint number) {
         uint returnedIntegerValue = Irandom(Ihouse(houseAddress).randomSource()).randNumber(die_min, die_faces);
         return  returnedIntegerValue;
    }

    //moves bet tokens from user to house, pays out minus house edge if user bet is correct, returns die rolls
    function bet(uint64 value, bool betIsEven) validBet(value) betInRange(value) public returns(uint8, uint8) {
        Ihouse(houseAddress).collectUserTokens(value, msg.sender);
        uint8 die1Value = uint8(roll());
        uint8 die2Value = uint8(roll());
        bool rollIsEven = ((die1Value + die2Value) % 2 == 0);
        if (rollIsEven == betIsEven){
            Ihouse(houseAddress).payUserTokens((2 * value - (value * house_edge/ 10000)), msg.sender);
        }
        return(die1Value, die2Value);
    }

    function test() public view returns(uint256){
        return(Ihouse(houseAddress).houseTokens());
    }
}