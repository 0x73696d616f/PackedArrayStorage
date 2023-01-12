// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract BytesContract {
    uint256 private BYTES_SLOT = uint256(keccak256("BYTES.SLOT"));

    event LogInterval(bytes2 interval);
    event LogReward(bytes1 reward);

    function set(bytes32[] calldata arrays) public {
        uint256 arraysLength_ = arrays.length;
        for(uint8 i = 0; i < arraysLength_; i++){
            _store(bytes32(BYTES_SLOT + i), arrays[i]);
        }
    }

    function getIntervalsRewards() public {
        bytes32 array_ = load(bytes32(BYTES_SLOT));
        uint8 numberOfArrays_ = uint8(bytes1(array_));
        uint8 i;
        array_ = array_ << 8;
        while (true) {
            while(array_ != 0) {
                // Get Interval
                emit LogInterval(bytes2(array_));
                array_ = array_ << 16;
                
                // Get Reward
                emit LogReward(bytes1(array_));
                array_ = array_ << 8;
            }
            i++;
            if (i >= numberOfArrays_) break;
            array_ = load(bytes32(BYTES_SLOT + i));
        }
    }

    function load(bytes32 slot_) public view returns (bytes32 array_) {
        assembly {
            array_ := sload(slot_)
        }
    }

    function _store(bytes32 slot_, bytes32 array_) internal {
        assembly {
            sstore(slot_, array_)
        }
    }
}
