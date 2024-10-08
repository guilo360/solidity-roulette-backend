// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "rng.sol";
import "gambling_house.sol";

interface Irandom {
    function randNumber(uint _low, uint _high) external returns (uint);
}

interface Ihouse{
    function houseTokens() external view returns (uint256);
    function weiPerToken() external view returns(uint32);
    function buyTokens(uint64 count, address user) external payable;
    function userTokens(address user) external view returns(uint64);
    function payUserTokens(uint64 count, address user) external;
    function collectUserTokens(uint64 count, address user) external;
    function randomSource() external view returns(address);
}

contract gambling {

    //Variables:
    address owner = msg.sender;
    address payable houseAddress = payable(0x4bd226DABEe1d2060B4b370774F4a6F097811C18); //needs to be set after the gambling house contract is live


    //Modifiers - https://solidity-by-example.org/function-modifier/
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }

    modifier validBet(uint64 value){
        require(Ihouse(houseAddress).userTokens(msg.sender) >= value, "Bet not possible - User can't afford bet"); //user has funds
        require(Ihouse(houseAddress).userTokens(msg.sender) + value < 2**64, "Bet not possible - Bet would put user over max tokens"); //bet would not overcap tokens
        require(value <= (Ihouse(houseAddress).houseTokens()), "Bet not possible - House can't afford payout"); //house can afford to pay out win
        _;
    }

//below modifiers likely redundant - to be removed if no individual necessity found, contained in validBet
    modifier userHasFunds(uint64 value) {
        require(Ihouse(houseAddress).userTokens(msg.sender) >= value);
        _;
    }
    
    modifier houseHasFunds(uint64 value) {
        require(value <= (Ihouse(houseAddress).houseTokens()));
        _;
    }

    modifier userCanStoreWinnings(uint64 value){
        require(Ihouse(houseAddress).userTokens(msg.sender) + value > 2**64);
        _;
    }

    // Functions:
    //change the house Addreess
    function changeHouse(address payable newHouse) public onlyOwner {
        houseAddress = newHouse;
    }
    //allow users to buy tokens through the interface instead of the house directly
    function buyTokens(uint64 amount)external payable returns(uint64){
        uint64 weiCost = amount * Ihouse(houseAddress).weiPerToken();
        require(msg.value == weiCost, "Incorrect amount of ether sent");
        Ihouse(houseAddress).buyTokens{value: msg.value}(amount, msg.sender);
        return(Ihouse(houseAddress).userTokens(msg.sender));
    }
}
