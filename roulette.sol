// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "gambling_interface.sol";


contract rouletteWheel is gambling{
    //Variables:
    uint wheelSize = 35;
    uint zeroes = 2;

//Main functions
    //a partially complete implimentation of spinning the wheel
    function spin() public 
    returns (uint number) {
         uint returnedIntegerValue = Irandom(Ihouse(houseAddress).randomSource()).randNumber(1,wheelsize+zeroes);
         return  returnedIntegerValue;
    }


    function getBalance() public view returns (uint){
        return address(this).balance;
    }

//useful information: https://ethereum.stackexchange.com/questions/109530/calling-function-from-another-contract
}
