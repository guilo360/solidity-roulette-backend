// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "rng.sol";

interface Irandom {
    function randNumber(uint _low, uint _high) external returns (uint);
}

contract rouletteWheel {
    //Variables:
    uint wheelSize = 36;
    address debugging_rng_sol_address = 0xEc29164D68c4992cEdd1D386118A47143fdcF142;
    address owner = msg.sender;
    uint maxBet = 1;

    //Modifiers - https://solidity-by-example.org/function-modifier/
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }


/* TODO
    modifier lessThanMaxBet() {

    }

    modifier greaterThanMinBet() {
        
    }

    modifier 
*/

//Main functions
    //a partially complete implimentation of spinning the wheel
    function spin() public 
    returns (uint number) {
         uint returnedIntegerValue = Irandom(debugging_rng_sol_address).randNumber(0,36);
         return  returnedIntegerValue;
    }


    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

 

//useful information: https://ethereum.stackexchange.com/questions/109530/calling-function-from-another-contract
}
