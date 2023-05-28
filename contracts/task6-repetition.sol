// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract ArrayStorage {
    uint256[] public array;
    address private calleeColiderAddress;

    constructor(address _calleeColiderAddress) {
        calleeColiderAddress = _calleeColiderAddress;
    }

    function collide() external {
        uint256[13] memory _arrey = [uint256(1), 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
        (bool success,) = calleeColiderAddress.delegatecall(abi.encodeWithSignature("callMe(uint256[])", 0x20, _arrey.length, _arrey));
        require(success, "Delegate Call was not successful");
    }

    function getArray() external view returns (uint256[] memory) {
        return array;
    }
}

contract CalleeColider {
    uint256[] public array = [1,2,3,4,5,6,7,8,9,10,11,12,13];

    function callMe(uint256[] memory _array) external {
        array = _array;
    }
}
