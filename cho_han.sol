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
        require(value <= maxBet && value >= minBet, string(abi.encodePacked("best must be between ", uint2str(minBet), " and ", uint2str(maxBet))));
        require(value % (10000/house_edge) == 0, string(abi.encodePacked("bet must be a multiple of ", uint2str(10000/house_edge))));
        _;
    }

    //Main functions
    //roll a single die
    function roll() public 
    returns (uint number) {
         uint returnedIntegerValue = Irandom(Ihouse(houseAddress).randomSource()).randNumber(die_min, die_faces);
         return  returnedIntegerValue;
    }

    //makes bet if it's valid, returns die roll for front end
    function bet( bool betIsEven, uint64 value) validBet(value, 1) betInRange(value) public returns(uint8, uint8, bool) {
        uint64 payout = Ihouse(houseAddress).holdTokens(value, msg.sender, value - (value * house_edge/10000));
        uint8 die1Value = uint8(roll());
        uint8 die2Value = uint8(roll());
        bool rollIsEven = ((die1Value + die2Value) % 2 == 0);
        if (rollIsEven == betIsEven){
            Ihouse(houseAddress).payOut(payout, msg.sender);
            return(die1Value, die2Value, true);
        }
        else{
            Ihouse(houseAddress).payOut(payout, houseAddress);
            return(die1Value, die2Value, false);
        }
    }
}