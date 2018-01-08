pragma solidity ^0.4.17;

library Structs {

    struct Bounty {
        address public creator;
        byte32 public targetName;
        byte32 public targetDescription;
        uint public ethPrice;

        address public fulfiller;
        byte32 public fulfillerName;
        bool public fulfilled;
    }

}