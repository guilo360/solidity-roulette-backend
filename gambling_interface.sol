// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "rng.sol";
import "gambling_house.sol";

interface Irandom {
    function randNumber(uint _low, uint _high) external returns (uint);
}

interface Ihouse{
    function weiPerToken() external view returns(uint32);
    function buyTokens(uint64 count) external payable;
    function userBalance(address user) external view returns(uint64);
}

contract gambling {

    //Variables:
    address owner = msg.sender;
    address payable houseAddress = payable(0x9C9fF5DE0968dF850905E74bAA6a17FED1Ba042a); //needs to be set after the gambling house contract is live


    //Modifiers - https://solidity-by-example.org/function-modifier/
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }

    modifier validBet(uint64 value){
        require(Ihouse(houseAddress).userBalance(tx.origin) >= value, "User can't afford bet"); //user has funds
        require(Ihouse(houseAddress).userBalance(tx.origin) + value > 2**64, "Bet would put user over max tokens"); //bet would not overcap tokens
        uint64 payout = value*2;
        require(payout <= (address(houseAddress).balance * Ihouse(houseAddress).weiPerToken()), "House can't afford payout"); //house can afford to pay out win
        _;
    }

//below modifiers likely redundant - to be removed if no individual necessity found, contained in validBet


    modifier userHasFunds(uint64 value) {
        require(Ihouse(houseAddress).userBalance(tx.origin) >= value);
        _;
    }
    
    modifier houseHasFunds(uint64 payout) {
        require(payout <= (address(houseAddress).balance * Ihouse(houseAddress).weiPerToken()));
        _;
    }

    modifier userCanStoreWinnings(uint64 value){
        require(Ihouse(houseAddress).userBalance(tx.origin) + value > 2**64);
        _;
    }

    // Functions
    function buyTokens(uint64 amount)external payable returns(uint64){
        uint64 weiCost = amount * Ihouse(houseAddress).weiPerToken();
        require(msg.value == weiCost, "Incorrect amount of ether sent");
        Ihouse(houseAddress).buyTokens{value: msg.value}(amount);
        return(Ihouse(houseAddress).userBalance(tx.origin));
    }

    function balance() external view returns(uint64){
        return(Ihouse(houseAddress).userBalance(tx.origin));
    }


    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

}
