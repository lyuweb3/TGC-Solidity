// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

/**
 * @title FixedDepositBox
 * @dev calculate return amount with inputs amount invested, duration and interest rate per hous
 */

 contract FixedDepositBox {
    address public owner;

    struct DepositDetails {
        uint256 amount;
        uint256 duration; // value 5, 10 or 15
        uint256 startTime;
        uint256 amountplusinterest = 0;
        uint8 rateperhour;
        bool withdrawn = false;
        // string password;
    }

    DepositDetails Deposit;

    // mapping(address ==> Deposit) public deposits;
    /* @dev create events to allow front-end interaction
     event DespositMade(address indexed depositer, uint256 amt, uint256 duration, uint256 rateperhour, uint256 startTime);
     event Withdrawal(address indexed withdrawer, uint256 amt);
    */

    constructor(uint256 amtInvest, uint256 duration, uint8 rateperhour) {
        require(amtInvest > 0, "Deposit amount must be more than zero dollars.");
        require(duration == 5 || duration == 10 || duration == 15, "Duration must be 5minutes, 10minutes, 15minutes");
        require(rateperhour > 0, "Interest rate per hour must be greater than zero.");
        Deposit.amount = amtInvest;
        Deposit.duration = duration;
        Deposit.startTime = block.timestamp;
        Deposit.rateperhour = rateperhour;
        owner = msg.sender;
    }
    
   /* modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action.");
        _;
    } */

    function calculateInterestPayable() internal pure returns (uint256) {
        return Deposit.amount * Deposit.rateperhour * Deposit.duration / 60 /100;
    }

    function withdrawal () external returns (uint256) {
        require(!Deposit.withdrawn, "One withdrawal has been done, no further withdrawal allowed.");
        require(block.timestamp >= Deposit.startTime + Deposit.duration * 1 minutes, "Deposit duration not elapsed!");

        uint256 interest = calculateInterestPayable ();
         
        Deposit.withdrawn = true;

        return Deposit.amount + interest;

       // emit Withdrawal(msg.sender, returnAmt);
    }
}