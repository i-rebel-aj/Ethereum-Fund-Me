// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    /**
        Get Price
        ABI:
        Contract Address:0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
    **/
    function getPrice() internal view returns (uint256){
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        //Price is value of 1 ETH in USD
        (,int price,,,) =priceFeed.latestRoundData();

        return uint256(price*1e10);
    }
    /**
        Returns Value of x amount of ether in USD 
    **/
    function getConversionRate(uint256 ethAmount) internal view returns (uint256){
        return (ethAmount * getPrice())/1e18;
    }
}
