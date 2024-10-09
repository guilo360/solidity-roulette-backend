// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "gambling_interface.sol";


contract rouletteWheel is gambling{
    //Variables:
    uint8 wheelSize = 36;
    uint8 zeroes = 2;
    uint64 public maxBet = 1000000;
    uint64 public minBet = 1000;
   

    //Modifiers:

    modifier betInRange(uint64 value) {
        require(value <= maxBet && value >= minBet, string(abi.encodePacked("best must be between ", uint2str(minBet), " and ", uint2str(maxBet))));
        _;
    }



    //Main functions
   
    //spin the wheel, returning a location on the wheel, with anything higher than wheelSize acting as a 0 value (does not return 0)
    function spin() public 
    returns (uint8 number) {
         uint8 returnedIntegerValue = Irandom(Ihouse(houseAddress).randomSource()).randNumber(1,wheelSize+zeroes);
         return  returnedIntegerValue;
    }

    //functional bet code - bet is made as array of applicable values - frontend API likely beneficial.
    //technically allows non-standard bets, but payouts would be calculated at same rates as standard anyway - same price point.
    //returns result for front end use
    function bet(uint8[] calldata option, uint64 rate) validBet(rate, (wheelSize/uint8(option.length))) betInRange(rate) public returns (uint8 outcome){
        require(option.length < 19 && option.length > 0, "Invalid bet length");
        uint64 payout = Ihouse(houseAddress).holdTokens(rate, msg.sender, rate*(wheelSize/uint8(option.length)));
        uint8 result = spin();
        for(uint8 i=0; i < option.length; i++){
            if (option[i] == result){
          Ihouse(houseAddress).payUserTokens(payout, msg.sender);
            }
        }
        return (result);
    }
//useful information: https://ethereum.stackexchange.com/questions/109530/calling-function-from-another-contract
}
