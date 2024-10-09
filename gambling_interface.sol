// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "rng.sol";
import "gambling_house.sol";

interface Irandom {
    function randNumber(uint _low, uint _high) external returns (uint8);
}

interface Ihouse{
    function houseTokens() external view returns (uint256);
    function weiPerToken() external view returns(uint32);
    function buyTokens(uint64 count, address user) external payable;
    function holdTokens(uint64 payUser, address user, uint64 payHouse) external returns(uint64);
    function userTokens(address user) external view returns(uint64);
    function payUserTokens(uint64 count, address user) external;
    function randomSource() external view returns(address);
}

contract gambling {

    //Variables:
    address owner = msg.sender;
    address payable houseAddress = payable(0x6b8588E0BaAa2a027F0c7A5bA201D009bC76E459); //needs to be set after the gambling house contract is live


    //Modifiers - https://solidity-by-example.org/function-modifier/
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }
    //validate bet value
    modifier validBet(uint64 value, uint8 multiplier) {
        require(value < 18446744073709551615/multiplier, "Bet not possible - Payout would be more than max tokens"); //ensure payout is less than max int
        uint64 payout = value * multiplier;
        require(Ihouse(houseAddress).userTokens(msg.sender) >= value, "Bet not possible - User can't afford bet"); //user has funds
        require(Ihouse(houseAddress).userTokens(msg.sender) + payout < 2**64, "Bet not possible - Bet would put user over max tokens"); //bet would not overcap tokens
        require(payout <= (Ihouse(houseAddress).houseTokens()), "Bet not possible - House can't afford payout"); //house can afford to pay out win
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
    //Convert int to string
    //AI generated code - found a few sources of human code but none that compiled correctly, this one worked for every value I tested it with.
    //used for clearer error messages
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
