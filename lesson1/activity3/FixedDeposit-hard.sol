// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

 /*
 * @title FixedDepositBox that can send and receive tokens
 * @dev receive and send tokens
 * @custom: dev-run-script ./script/deploy_with_ethers.js
 */

 contract FixedDepositBox_Hard {
    // contract beginning value
    uint256 constant SECONDS_IN_MINUTES = 60;
    uint256 durationInMinutes;
    uint256 totalBalance;
    uint8 rateperhour;

    // Array to keep track of user address
    address[] usersAddress;

    // Map to keep track of users' passwords
    mapping(address => string) passwordMap;

    // Map to keep track of users' invested amount
    mapping(address => uint) amtDepositedMap;

    // Map to keep track of users' time of deposit 
    mapping(address => uint) timeDepositedMap;
 

    constructor (uint256 _amt, uint256 _dur, uint8 _rate) {
        require(_dur == 5 || _dur == 10 || _dur == 15, "Duration must be 5, 10 or 15 minutes.");

        // set the state variables
        durationInMinutes = _dur;
        totalBalance = _amt;
        rateperhour = _rate;
    }

    function userExist(address _addr) public view returns (bool) {
        for (uint256 i =0; i < usersAddress.length; i++) {
            if (usersAddress[i] == _addr) {
                return true;
            }
        }
        return false;
    }

    // receive function to handle the receiving of ether
    receive() external {
        address userAddress = msg.sender;

        uint256 amtReceived = msg.value;

        totalBalance += amtReceived;

        amtDepositedMap[userAddress] = amtReceived;
    }

   function deposit(string calldata password) external payable {
        address userAddress = msg.sender;

        // check that user has not deposited
        require(!userExist(userAddress), "You have already deposited.");

        // add user to usersAddress Array
        usersAddress.push(userAddress);

        // add user's password to passwordMap
        passwordMap[userAddress] = password;

        // add user's time deposited to timeDepositedMap
        timeDepositedMap[userAddress] = block.timestamp;
   }

    function withdrawal(string memory _pwd) external {
        address userAddress = msg.sender;

        // require that the user has made a deposit;
        require(userExist(userAddress), "You have not made any desposit.");

        // validate password
        string memory userPwd = passwordMap[userAddress];

        require(
            keccak256(abi.encodePacked(_pwd)) == keccak256(abi.encodePacked(userPwd)), "The password does not match."
        );

        // get user's amount deposited
        uint256 userAmt = amtDepositedMap[userAddress];

        // get user's time deposited
        uint256 userTimeDeposited = timeDepositedMap[userAddress];

        // get time now
        uint timeNow = block.timestamp;

        // set bool variable to determine if required duraiton has elapsed
        bool userCanWithdraw = timeNow > userTimeDeposited + durationInMinutes;

        // check condition fulfilled before allowing withdrawal
        if (userCanWithdraw) {

            // calculate amount to be returned to user
            uint256 interestEarned = (userAmt * durationInMinutes * rateperhour) / SECONDS_IN_MINUTES / 100;
            uint256 returnAmt = interestEarned + userAmt;

            // decrease contrac's balance by the total amount to be returned to user
            totalBalance -= returnAmt;

            // pay user initial amount & interest earned
            (bool success, ) = payable(userAddress).call{value: 0}("");
            require(success, "Withdrawal failed");
        }
    }
}