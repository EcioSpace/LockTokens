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

    address public ECIO_TOKEN;

    uint8 public constant PERIOD_1ST  = 1;
    uint8 public constant PERIOD_2ND  = 2;

    mapping(uint8 => timeAndAmount) public periodTimeandAmount;

    struct timeAndAmount{
      uint256 time;
      uint256 amount;
    }

    constructor(
        address _ecioTokenAddr,
        uint256 _firstRealeaseTime,
        uint256 _firstRealeaseAmount,
        uint256 _secondRealeaseTime,
        uint256 _secondRealeaseAmount
    ) {
        ECIO_TOKEN = _ecioTokenAddr;

        periodTimeandAmount[PERIOD_1ST].time = _firstRealeaseTime;
        periodTimeandAmount[PERIOD_1ST].amount = _firstRealeaseAmount;

        periodTimeandAmount[PERIOD_2ND].time = _secondRealeaseTime;
        periodTimeandAmount[PERIOD_2ND].amount = _secondRealeaseAmount;
    }


  function _transferToOwner(address _owner, uint8 _periodId) public onlyOwner nonReentrant {
        uint256 amount =  periodTimeandAmount[_periodId].amount;

        require( block.timestamp >= periodTimeandAmount[_periodId].time, "RealeaseTime: Your time has not come" );

        IERC20(ECIO_TOKEN).transfer(_owner, amount);
    }

  function checkIsAvailable(uint8 _periodId) public view returns (bool) {
        if( block.timestamp >= periodTimeandAmount[_periodId].time ) {
          return true;
        } else {
          return false;
        }
  }

}
