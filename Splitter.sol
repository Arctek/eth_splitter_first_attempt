pragma solidity ^0.4.18;

/*
 * Splitter.sol
 * 
 */
contract Splitter {
    address private alice;
    address private bob;
    address private carol;
    
    uint256 public bobBalance;
    uint256 public carolBalance;
    
    bool changeTurn;

    function Splitter(address bobAddress, address carolAddress) public {
        // Don't allow null addresses for bob or alice
        if (bobAddress == address(0)) {
            revert();
        }
        if (carolAddress == address(0)) {
            revert();
        }
        
        alice = msg.sender;
        bob = bobAddress;
        carol = carolAddress;
    }
    
    function split() payable public returns(bool success) {
        if (msg.sender != alice) {
            revert();
        }
        
        uint256 quotient  = msg.value / 2;
        uint256 remainder = msg.value - 2 * quotient;
        
        // Send something half decent, can't split camel hairs
        if (quotient < 1) {
            revert();
        }
        
        bobBalance += quotient;
        carolBalance += quotient;
        
        // Well someone has to get get it, let them take turns
        if (changeTurn) {
            bobBalance += remainder;
            changeTurn = false;
        }
        else {
            carolBalance += remainder;
            changeTurn = false;
        }
        
        return true;
    }
    
    function withdraw() public returns(bool success) {
        uint256 payeeBalance;
        
        // Should be either bob/carol, and can't withdraw multiple times
        if (msg.sender == bob) {
            payeeBalance = bobBalance;
            bobBalance = 0;
        }
        else if (msg.sender == carol) {
            payeeBalance = carolBalance;
            carolBalance = 0;
        }
        else {
            revert();
        }
        
        if (payeeBalance == 0) {
            revert();
        }
        
        if (!msg.sender.send(payeeBalance)) {
            revert();
        }
        
        return true;
    }
}