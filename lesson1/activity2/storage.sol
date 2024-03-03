// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {
    uint256 unlockTime;
    uint256 number;
    uint8[10] dataArray;

    // TODO: Task 1
    // 1. Change the constructor function to take in a parameter of type uint256 called duration
    // 2. Assign the state variable unlockTime to be the addition of currentTime and duration

    // CODE BLOCK //
    constructor(uint256 duration) {
    // END OF CODE BLOCK //

        uint256 currentTime = block.timestamp; // The current time when the smart contract is deployed

        // CODE BLOCK //
        unlockTime = currentTime + duration;

        // END OF CODE BLOCK //

        uint8 i = 1;
        while(i < 11) {
            dataArray[i-1] = i;
            i++;
        }
    }


    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    /**
     * @dev Return value
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        uint256 timeNow = block.timestamp; // The current time when the retrieve function is called

        // CODE BLOCK //
        if (timeNow > unlockTime) {
            return number:
        } else {
                return 0;
            }

        // END OF CODE BLOCK //

        // TODO: Task 2
        // 1. Use a control flow to change the amount code so that it will only return
        //    the state variable number if the timeNow is greater than the unlockTime
        //    if not the function should return 0
    }

    /**
     * @dev Gets the sum of the data array based on the input into the function
     * @param n how many numbers you would like to add up
     * @return sum of the n number of items in the data array
     */
    function getSum(uint256 n) public view returns (uint8){
        uint count = 0;
        uint sum = 0;
        require(n <= 10, "Input should be less than or equal to 10");
        require(n <> 0, "Input cannot be zero");
        // CODE BLOCK //
        while (count < n) {
            sum = sum + dataArray[count];
            count++;
        }
        return sum;
        // END OF CODE BLOCK //

        // TODO: Task 3
        // 1. Use a control flow to add up the contents of the dataArray from index 0 to
        //    index n (n is a parameter of the function getSum). Output the sum.
    }

}