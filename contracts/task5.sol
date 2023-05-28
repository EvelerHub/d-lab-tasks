// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

struct Point {
    uint256 x;
    uint256 y;
}

contract UintStorage {
    uint256 private one;
    mapping(uint256 => Point) private pointMap;

    constructor() {
        one = 1;
        pointMap[12] = Point(12, 12);
    }

    function setNewValues(uint256 first, Point calldata point) external virtual {}

    function getStorageValuesSum() external view returns (uint256) {
        return one + pointMap[12].x + pointMap[12].y;
    }

    function getMapValue(uint256 key) external view returns (Point memory) {
        return pointMap[key];
    }
}

contract StrangeCalculator is UintStorage {
    function setNewValues(uint256 first, Point calldata point) external override {
        assembly {
            // element key
            mstore(0x0, 12)
            // mapping slot location
            mstore(0x20, 0x01)
            // slot of `x` of key `12` 
            let slot1 := keccak256(0, 0x40)
            // slot of `y` of key `12` 
            let slot2 := add(keccak256(0, 0x40), 1)
            
            
            let x := calldataload(0x24)
            sstore(slot1, x)
            
            let y := calldataload(0x44)
            sstore(slot2, y)
            
            sstore(0x0, first)
        }
    }
}
