// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract gamblingHouse{

    //Variables:
    address owner = msg.sender;
    mapping (address => uint64) public userTokens;
    uint32 public weiPerToken = 100; 


    //Modifiers - https://solidity-by-example.org/function-modifier/
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }

    //Functions:

    //add tokens to user account in exchange for eth - uses tx.origin as it can be called through the interface
    function buyTokens(uint64 count) public payable{
        require(userTokens[tx.origin]+count < 2**64, "user tokens cannot exceed 2^64");
        require(msg.value == count * weiPerToken, "Incorrect amount of ether sent");
        userTokens[tx.origin] += count;
    }
    //check user balance for a given address from userTokens dictionary
    function userBalance(address user) public view returns(uint64){
        return userTokens[user];
    }


    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

}
