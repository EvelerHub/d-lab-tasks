// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
//import "hardhat/console.sol";

interface IDataTypesPractice {
    function getInt256() external view returns (int256);

    function getUint256() external view returns (uint256);

    function getInt8() external view returns (int8);

    function getUint8() external view returns (uint8);

    function getBool() external view returns (bool);

    function getAddress() external view returns (address);

    function getBytes32() external view returns (bytes32);

    function getArrayUint5() external view returns (uint256[5] memory);

    function getArrayUint() external view returns (uint256[] memory);

    function getString() external view returns (string memory);

    function getBigUint() external pure returns (uint256);
}

contract DataTypesPractice is IDataTypesPractice {

    int256 public integer256;
    
    uint256 public unsignedInteger256;
    
    int8 public integer8;
    
    uint8 public unsignedInteger8;
    
    bool public boolean;

    address public anAddress;

    bytes32 public someBytes32;

    uint256[5] public unsignedInteger256StaticArray;

    uint256[] public unsignedInteger256DynamicArray;

    string public aString;


    constructor() {
        integer256 = -123;
        unsignedInteger256 = 123;
        integer8 = -1;
        unsignedInteger8 = 1;
        boolean = true;
        anAddress = address(666);
        someBytes32 = "Goodbye World!";
        unsignedInteger256StaticArray = [1, 2, 3, 5, 6];

        unsignedInteger256DynamicArray.push(1);
        unsignedInteger256DynamicArray.push(2);
        
        aString = "Hello World!";
    }


    function getInt256() external view returns (int256) {
        return integer256;
    }

    function getUint256() external view returns (uint256){
        return unsignedInteger256;
    }

    function getInt8() external view returns (int8) {
        return integer8;
    }

    function getUint8() external view returns (uint8) {
        return unsignedInteger8;
    }

    function getBool() external view returns (bool) {
        return boolean;
    }

    function getAddress() external view returns (address) {
        return anAddress;
    }

    function getBytes32() external view returns (bytes32) {
        return someBytes32;
    }

    function getArrayUint5() external view returns (uint256[5] memory) {
        return unsignedInteger256StaticArray;
    }

    function getArrayUint() external view returns (uint256[] memory) {
        return unsignedInteger256DynamicArray;
    }

    function getString() external view returns (string memory) {
        return aString;
    }

    function getBigUint() external pure returns (uint256) {
        uint256 v1 = 1;
        uint256 v2 = 2;
        return ~v2+v1;
    }


}