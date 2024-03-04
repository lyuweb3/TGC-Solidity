// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

/**
 * @title FixedDepositBox
 * @dev calculate return amount with inputs amount invested, duration and interest rate per hous
 */

 contract FixedDepositBox {
    address public owner;
    uint256 public totalAmount;

    struct Deposit {
        uint256 amount;
        uint256 duration;
        uint256 startTime;
        uint256 rateperhour;
        uint256 amountplusinterest;
        bool withdrawn;
        string password;
    }

    mapping(address ==> Deposit) public deposits;

    event DespositMade(address indexed depositer, uint256 amt, uint256 duration, uint256 rateperhour, uint256 startTime);
    event Withdrawal(address indexed withdrawer, uint256 amt);

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action.");
        _;
    }

    function deposit(uint256 _amt, uint256 _dur, uint256 _rate, string memory _pwd) external payable {
        require(_amt > 0, "Deposit amount must be greater than zero dollars!");
        require(_dur == 5 || _duration == 10 || _duration == 15, "Invalid duration");
        require(_rate > 0, "Interest rate per hour must be greater than zero!");
        
        uint256 interest = calculateInterestPayable(_amt, _dur, _rate);
        totalAmount = _amt + interest;
        uint256 currTime = block.timestamp;

        deposits[msg.sender] = Deposit({
            amount = _amt,
            duration = _dur,
            startTime = currTime,
            rateperhour = _rate,
            amountplusinterest = totalAmount;
            withdrawn = false,
            password = _pwd,
        });

        emit DepositMade(msg.sender, _amt, _dur, _rate, currTime);
    }

    function calculateInterestPayable(uint256 _amt, uint256 _dur, uint256 _rate) internal pure returns (uint256) {
        uint256 interest = (_amt * _rate * _dur) / 60 / 100;
        return interest;
    }

    function withdrawal(string memory _pwd) external {
        Deposit storage userDeposit = deposits[msg.sender];
        require(userDeposit.password == _pwd, "Password does not match, denied!");
        require(userDeposit.amount > 0, "No deposit found");
        require(!userDeposit.withdrawn, "Deposit already withdrawn!");
        require(block.timestamp >= userDeposit.startTime + userDeposit.duration * 1 minutes, "Deposit duration not elapsed!");

        uint256 returnAmt = userDeposit.amountplusinterest;
         
        userDeposit.withdrawn = true;

       emit Withdrawal(msg.sender, returnAmt);
    }
}