// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BytesContract.sol";

contract BytesContractTest is Test {
    BytesContract _bytesContract;

    function setUp() public {
        _bytesContract = new BytesContract();
    }

    function testSetAndGet() public {
        uint8 numberOfIntervals_ = 10;
        uint16[] memory intervals_ = new uint16[](numberOfIntervals_);
        uint8[] memory rewards_ = new uint8[](numberOfIntervals_);
        for (uint8 i = 0; i < numberOfIntervals_; i++) {
            intervals_[i] = i + 1;
            rewards_[i] = i + 11;
        } 

        bytes32 bytesIntervalsRewards_ = bytes32(bytes1(uint8(1)));
        uint256 lastIntervalJump_ = 8 + 24*(intervals_.length - 1);
        console.log("Set bytes"); 
        for (uint256 jump = 8; jump <= lastIntervalJump_; jump += 24) {
            // Set the current max interval block diff 
            bytesIntervalsRewards_ = bytesIntervalsRewards_ | bytes32(bytes2((intervals_[(jump - 8)/24]))) >> jump;
            // Set the current reward for that interval
            bytesIntervalsRewards_ = bytesIntervalsRewards_ | bytes32(bytes1((rewards_[(jump - 8)/24]))) >> (jump + 16);
        }
        console.logBytes32(bytesIntervalsRewards_);

        bytes32[] memory bytesArray_ = new bytes32[](1);
        bytesArray_[0] = bytesIntervalsRewards_;
        _bytesContract.set(bytesArray_);

        _bytesContract.getIntervalsRewards();
    }
}
