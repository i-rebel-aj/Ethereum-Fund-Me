// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "./PriceConverter.sol";
error NotOwner();
error WithdrawFailed();
error NotMinEth();
contract FundMe{
    using PriceConverter for uint256;
    uint256 public constant minimumUSD=50*1e18;
    address[] public funders;
    mapping(address=>uint256) public addressToAmountFunded;
    address public immutable owner;
    constructor(){
        owner=msg.sender;
    }
    function fund() public payable{
        if(msg.value.getConversionRate() <minimumUSD){
            revert NotMinEth();
        }
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]+=msg.value;
    }

    
    function withdraw() public onlyOwner{
        for(uint256 index=0; index<funders.length; index++){
            addressToAmountFunded[funders[index]]=0;
        }
        funders=new address[](0);
        //Three different ways to withdraw funds
        /*
            Refer: https://solidity-by-example.org/sending-ether/
            1. Transfer
            2. Send
            3. Call
        */
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        if(!callSuccess){
            revert WithdrawFailed();
        }
    }

    modifier onlyOwner(){
        if(msg.sender!=owner){
            revert NotOwner();
        }
        //_; Specifies the order in which modifier and rest of code is executed
        _;
    }
    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
