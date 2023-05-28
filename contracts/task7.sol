// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

abstract contract AuthorizedValue {
    uint256 private value;

    address private messageOwner = 0x5A902DB2775515E98ff5127EFEa53D1CC9EE1912;

    function setValueRaw(
        uint256 value_,
        bytes32 messageHash,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) public {
        address signer = ecrecover(messageHash, v, r, s);

        require(signer == messageOwner, "Invalid signature.");

        value = value_;
    }

    function setValue(uint256 value_, bytes memory signature) external virtual;

    function getValue() external view returns (uint256) {
        return value;
    }

    function getMessageOwner() external view returns (address) {
        return messageOwner;
    }
}

contract ValueSetter is AuthorizedValue {
    uint256 private nonce;

    function setValue(uint256 value_, bytes memory signature) external override {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(signature);
        bytes32 messageHash = toHash(value_);
        setValueRaw(value_, messageHash, r, s, v);
    }
    
    function splitSignature(bytes memory sig) private pure returns (uint8, bytes32, bytes32) {
       require(sig.length == 65, "signature is longer than 65  byetes");

       bytes32 r;
       bytes32 s;
       uint8 v;

       assembly {
           // first 32 bytes, after the length prefix
           r := mload(add(sig, 32))
           // second 32 bytes
           s := mload(add(sig, 64))
           // final byte (first byte of the next 32 bytes)
           v := byte(0, mload(add(sig, 96)))
       }
     
       return (v, r, s);
   }

   function toHash(uint256 value_) private view returns(bytes32) {
       uint256 chainId = block.chainid;
       bytes32 message = keccak256(abi.encode(value_, chainId, "ValueSetter"));
       return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", message));
    }
}
