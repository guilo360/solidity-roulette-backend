// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//this contract is a library of random number functions that will be used by the roulette contract

contract random {
    uint calledBefore;
//This function only gets the current blocks hash, and is an insecure random hash generator

    function randHash() public 
    returns (uint _randomhash)
    {
        bytes32 seed = bytes32(block.timestamp + calledBefore);
        calledBefore++;
        return uint256(bytes32(keccak256(abi.encodePacked(seed))));

    }

//turns the above hash function into a random number within the range (high) and (low)
//This is implimented this way so that alternative random hash functions can be implimented without breaking other code
//only works for numbers >0
//a full library would be better but this suits for the roulette wheel
    function randNumber(uint _low, uint _high) external 
    returns (uint randomInRange) 
    {
        uint hash = randHash();
        return hash % (_high + 1 - _low) + _low;
    }

}
