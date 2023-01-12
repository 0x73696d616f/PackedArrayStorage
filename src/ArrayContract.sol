// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ArrayContract {
    uint16[] _arrayTest;

    event LogInterval(bytes2 interval);
    event LogReward(bytes2 reward);

    function set(uint16[] memory arrayTest_) public {
        _arrayTest = arrayTest_;
    }

    function getIntervalsRewards() public {
        for(uint16 i = 0; i < _arrayTest.length; i++){
            if(i % 2 != 0) 
                emit LogInterval(bytes2(_arrayTest[i]));
            else
                emit LogReward(bytes2(_arrayTest[i]));
        }
    }
}
