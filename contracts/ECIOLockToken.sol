// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

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

    mapping(uint8 => timeAndAmount) periodTimeandAmount;

    struct timeAndAmount{
      uint256 time;
      uint256 amount;
    }

    constructor(
        address _ecioTokenAddr

    ) {
        ECIO_TOKEN = _ecioTokenAddr;

        periodTimeandAmount[PERIOD_1ST].time = 1640008800;
        periodTimeandAmount[PERIOD_2ND].time = 1671570000;

    }


  function setPeriodReleaseTime(uint8 _periodId, uint256 _releaseTime) public onlyOwner{
      periodTimeandAmount[_periodId].time = _releaseTime;
  }

  function setAmountPerPeriod(uint8 _periodId, uint256 _amount) public onlyOwner{
      periodTimeandAmount[_periodId].amount = _amount;
  }

  function _transferToOwner(address _owner, uint256 _amount, uint8 _periodId) public onlyOwner nonReentrant {
        require( block.timestamp >= periodTimeandAmount[_periodId].time, "RealeaseTime: Your time has not come" );
        require( _amount <= periodTimeandAmount[_periodId].amount, "Amount: Token amount is too high" );
        IERC20(ECIO_TOKEN).transfer(_owner, _amount);
    }

  function checkIsAvailable(uint8 _periodId) public view returns (bool) {
        if( block.timestamp >= periodTimeandAmount[_periodId].time ) {
          return true;
        } else {
          return false;
        }
  }

}
