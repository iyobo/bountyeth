pragma solidity ^0.4.17;

library Structs {

    struct Bounty {
        address creator;
        byte32 targetName;
        byte32 targetDescription;
        uint ethPrice;

        address fulfiller;
        byte32 fulfillerNickname; //optional. In case the bounty hunter that fulfilled this wants to market their name.
        bool fulfilled;
    }

}