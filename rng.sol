// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//this contract is a library of random number functions that will be used by the roulette contract

contract random {

//This function only gets the current blocks hash, and is an insecure random hash generator

    function randHash() public view
    returns (uint _randomhash)
    {
        bytes32 seed = blockhash(block.number);
        return uint256(bytes32(keccak256(abi.encodePacked(seed))));

    }

//turns the above hash function into a random number within the range (high) and (low)
//This is implimented this way so that alternative random hash functions can be implimented without breaking other code
//note - due to the nature of the blockchain any waiting till a new block has been mined should be handeled by the front end.
//Following this, this function will then be called to generate a random number.


    function randNumber(uint _low, uint _high) public view
    returns (uint randomInRange) 
    {
        uint hash = randHash();
        return hash % (_high + 1 - _low) + _low;
    }

}
