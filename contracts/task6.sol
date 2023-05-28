// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

abstract contract ArrayStorage {
    uint256[] private array;

    function collide() external virtual;

    function getArray() external view returns (uint256[] memory) {
        return array;
    }
}

contract StorageCollider is ArrayStorage {
    address private calleeColiderAddress;

    constructor(address _calleeColiderAddress) {
        calleeColiderAddress = _calleeColiderAddress;
    }

    function collide() external override {
        (bool success,) = calleeColiderAddress.delegatecall(abi.encodeWithSignature("callMe()"));
        require(success, "Delegate Call was not successful");
    }
}

contract CalleeColider {
    uint256[] private array;

    function callMe() external {
        array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
    }
}