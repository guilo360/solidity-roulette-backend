// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "EnumerableSet.sol";

contract gamblingHouse{
    using EnumerableSet for EnumerableSet.AddressSet;

    //Variables:
    address owner = msg.sender;
    address public randomSource = 0xFb3C40a2F3a57a7DB3D8Cfa050a0fDa7Aed8399F; //modify before publishing or using function
    mapping (address => uint64) public userTokens;
    uint256 public houseTokens;
    uint256 fractionalTokens;
    uint32 public weiPerToken = 100;
    EnumerableSet.AddressSet private allowedInterfaces;

    //Modifiers - https://solidity-by-example.org/function-modifier/
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }

    modifier onlyInterface() {
        require(allowedInterfaces.contains(msg.sender), "Not interface");
        _;
    }

    //Functions:
    // Owner Configuration Functions:
    function changeRandomSource(address newSource) public onlyOwner() {
        randomSource = newSource;
    }

    function addInterface(address gameAddress) public onlyOwner{
        allowedInterfaces.add(gameAddress);
    }

    function removeInterface(address gameAddress) public onlyOwner{
        allowedInterfaces.remove(gameAddress);
    }

    function allowedInterfacesList() public view onlyOwner() returns (address[] memory){
        return(allowedInterfaces.values());
    }

    function changeOwner(address newOwner) public onlyOwner{
        owner = newOwner;
    }

    //Standard Functions:
    //add tokens to user account in exchange for eth, called from interface
    function buyTokens(uint64 count, address user) public payable{
        require(userTokens[user]+count < 2**64, "user tokens cannot exceed 2^64");
        require(msg.value == count * weiPerToken, "Incorrect amount of ether sent");
        userTokens[user] += count;
    }
    //overload to allow calling from house directly without assigning an address
    function buyTokens(uint64 count) public payable{
        require(userTokens[msg.sender]+count < 2**64, "user tokens cannot exceed 2^64");
        require(msg.value == count * weiPerToken, "Incorrect amount of ether sent");
        userTokens[msg.sender] += count;
    }

    //hold tokens for payout at start of bet - return value should be fed into payOut on a win
    function holdTokens(uint64 payUser, address user, uint64 payHouse) public onlyInterface returns(uint64 payout){
        require(houseTokens >= payHouse, "Insufficient house tokens");
        require(userTokens[user] >= payUser, "Insufficient user tokens");
        houseTokens -= payHouse;
        userTokens[user] -= payUser;
        return(payUser + payHouse);
    }

    //pay tokens into user account - should be used in tandem with holdTokens and count should be equal to holdTokens return value 
    function payOut(uint64 count, address user) public onlyInterface{
        if(user == address(this)){
            houseTokens += count;
        }
        else{
        userTokens[user] += count;
        }
    }

    //cash out user tokens for eth
    function cashOut(uint64 count) public { 
        require(count <= userTokens[msg.sender], "User can't cash out more than their own balance");
        userTokens[msg.sender] -= count;
        uint256 amountToSend = count * weiPerToken;
        payable(msg.sender).transfer(amountToSend);
    }
    //cash out house tokens for eth - Owner only
    function withdraw(uint256 count, address payable account) public onlyOwner {
        require(count <= houseTokens, "Can't withdraw more than the house has available");
        houseTokens -= count;
        uint256 amountToSend = count * weiPerToken;
        account.transfer(amountToSend);
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {
        fractionalTokens += msg.value % weiPerToken;
        houseTokens += msg.value / weiPerToken;
        if(fractionalTokens >= weiPerToken){
            fractionalTokens-weiPerToken;
            houseTokens++;
        }
    }

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

}
