// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract random {
    uint seed;
    uint random;

    function rand() public 
    returns (uint rand)
    {
        seed = block.timestamp;
        uint randomhash = uint256(bytes32(keccak256(abi.encodePacked(seed))));
        return randomhash;
    }

}