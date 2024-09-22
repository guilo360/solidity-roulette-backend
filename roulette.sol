// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "rng.sol";
import "hardhat/console.sol"

contract rouletteWheel {

    // Sets the range of numbers on the wheel
    uint wheelSize;

    //holds what colour each number (represented by an index value) is
    //I think this is more memory eficient than a mapping?
    //maybe impliment a custom colour type wrapping a string
    string[] wheelcolour;

    constructor() {
        wheelSize = 37;
        wheelcolour[0] = "green";
        
        //initialises odd numbers to be black
        for (uint i=1; i<=wheelSize; i = i +2) 
        {
            wheelcolour[i] = "black";
        }

        //initialises even numbers to be red
        for (uint i=2; i<=wheelSize; i = i +2) 
        {
            wheelcolour[i] = "red";
        }
    }

//In Progress

/*

    function spin() public 
    returns (uint number) {

    }

    function getColour (uint _number)
    returns (string colour) {
        return wheelcolour[_number];
    }

*/
}
