// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "gambling_interface.sol";


contract rouletteWheel is gambling{
    //Variables:
    uint wheelSize = 36;

//Main functions
    //a partially complete implimentation of spinning the wheel
    function spin() public 
    returns (uint number) {
         uint returnedIntegerValue = Irandom(msg.sender).randNumber(0,36);
         return  returnedIntegerValue;
    }


    function getBalance() public view returns (uint){
        return address(this).balance;
    }

//useful information: https://ethereum.stackexchange.com/questions/109530/calling-function-from-another-contract
}
