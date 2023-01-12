// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ArrayContract.sol";
import "../src/BytesContract.sol";

contract Deploy is Script {
    bytes32 private BYTES_SLOT = keccak256("BYTES.SLOT");
    ArrayContract _arrayContract;
    BytesContract _bytesContract;

    function run() public {
        // Deploy
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        _arrayContract = new ArrayContract();
        _bytesContract = new BytesContract();
        vm.stopBroadcast();

        uint8 numberOfIntervals_ = 10;
        uint16[] memory intervals_ = new uint16[](numberOfIntervals_);
        uint8[] memory rewards_ = new uint8[](numberOfIntervals_);
        for (uint8 i = 0; i < numberOfIntervals_; i++) {
            intervals_[i] = i + 1;
            rewards_[i] = i + 11;
        } 

        _setArray(intervals_, rewards_);
        _setBytes(intervals_, rewards_);

        _getIntervalsRewardsArray();
        _getIntervalsRewardsBytes();

    }

    //==============================================================================//
    //=== BytesContract functions                                                ===//
    //==============================================================================//

    /**
     * @dev First slot of array is number of bytes32 slots. The following values are: blockInterval, reward, blockInterval, reward, etc.
     */
    function _setBytes(uint16[] memory intervals_, uint8[] memory rewards_) internal {
        bytes32 bytesIntervalsRewards_ = bytes32(bytes1(uint8(1)));

        // jumps = 8 + 16*n + 8*n = 8 + 16*n + 8*n
        // ex of bits: 8 16 8 16 8
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

        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        _bytesContract.set(bytesArray_);
        vm.stopBroadcast();
    }

    function _getBytes(uint8 numberOfIntervals_) internal {
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        bytes32 array_ = _bytesContract.load(BYTES_SLOT);
        vm.stopBroadcast();

        uint16[] memory intervals_ = new uint16[](numberOfIntervals_);
        uint8[] memory rewards_ = new uint8[](numberOfIntervals_);
        uint256 i = 0;
        console.log("Get bytes");
        array_ = array_ << 8;
        while(array_ != 0) {
            // Get Internal
            intervals_[i] = uint16(bytes2(array_));
            array_ = array_ << 16 ;
            // Get Reward
            rewards_[i] = uint8(bytes1(array_));
            array_ = array_ << 8;
            // increment
            i++;
        }

        for(i; i < intervals_.length; i++){
            console.log("Interval: ", intervals_[i]);
            console.log("Reward: ", rewards_[i]);
        }
    }

    function _getIntervalsRewardsBytes() internal {
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        _bytesContract.getIntervalsRewards();
        vm.stopBroadcast();
    }

    //==============================================================================//
    //=== ArrayContract functions                                                ===//
    //==============================================================================//

    function _getIntervalsRewardsArray() internal {
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        _arrayContract.getIntervalsRewards();
        vm.stopBroadcast();
    }

    function _setArray(uint16[] memory intervals_, uint8[] memory rewards_) internal {
        uint16[] memory arrayTest_ = new uint16[](intervals_.length*2);

        for(uint16 i = 0; i < intervals_.length; i++){
            i % 2 == 0 
            ? arrayTest_[i] = intervals_[i] 
            : arrayTest_[i] = rewards_[i];
        }

        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        _arrayContract.set(arrayTest_);
        vm.stopBroadcast();
    }
}
