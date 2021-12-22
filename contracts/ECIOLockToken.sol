// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

//    ########    #####     ##     #####
//    ##         ##    ##   ##   ##     ##
//    ##        ##          ##  ##       ##
//    ########  ##          ##  ##  ^_^  ##
//    ##        ##          ##  ##       ##
//    ##         ##    ##   ##   ##     ##
//    ########    #####     ##     #####

/// @author ECIO Engineering Team
/// @title Claimtoken Smart Contract

contract ECIOLockToken is Ownable, ReentrancyGuard {

    //ECIO token Address
    address public ECIO_TOKEN;

    //Numbers of period of time, date, amount, isClaim.
    timeAndAmount[] public periodId;


    struct timeAndAmount{
      uint256 timeDate;
      uint256 amountPerPeriod;
      bool isClaim;
    }

    constructor(
        address _ecioTokenAddr,
        uint256[] memory _timeDate,
        uint256 _amountPerPeriod

    ) {
        require(_ecioTokenAddr != address(0), "Vesting: Invalid token address");
        ECIO_TOKEN = _ecioTokenAddr;

        for (uint256 i = 0; i < _timeDate.length; i++) {
        periodId.push(timeAndAmount(_timeDate[i], _amountPerPeriod, false));
        }
    }

  function realeaseTheTokens(address _address, uint8 _periodId) public onlyOwner nonReentrant {
        uint256 amount =  periodId[_periodId].amountPerPeriod;

        require( periodId[_periodId].isClaim == false, "Claim: This period is claimed." );
        require( block.timestamp >= periodId[_periodId].timeDate, "RealeaseTime: Your time has not come." );

        periodId[_periodId].isClaim = true;
        IERC20(ECIO_TOKEN).transfer(_address, amount);
    }


  function checkIsAvailable(uint8 _periodId) public view returns (bool) {
        if( block.timestamp >= periodId[_periodId].timeDate ) {
          return true;
        } else {
          return false;
        }
  }

}
