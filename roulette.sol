// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "gambling_interface.sol";


contract rouletteWheel is gambling{
    //Variables:
    uint8 wheelSize = 35;
    uint8 zeroes = 2;


//Main functions
    //a partially complete implimentation of spinning the wheel
    function spin() public 
    returns (uint8 number) {
         uint8 returnedIntegerValue = Irandom(Ihouse(houseAddress).randomSource()).randNumber(1,wheelSize+zeroes);
         return  returnedIntegerValue;
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    //functional bet code no payout - bet is made as array of applicable values - frontend API likely beneficial.
    //technically allows non-standard bets, but payouts would be calculated at same rates as standard anyway.
    //actual gambling functionality still to be implemented
    function bet(uint8[] calldata option, uint64 rate) public returns (bool win, uint8 outcome){
        require(option.length < 19 && option.length > 0, "Invalid bet length");
        uint8 result = spin();
        uint8 payout = (wheelSize / uint8(option.length));
        for(uint8 i=0; i < option.length; i++){
            if (option[i] == result){
                return(true, result);
            }
        }
        return (false, result);
    }
//useful information: https://ethereum.stackexchange.com/questions/109530/calling-function-from-another-contract
}
