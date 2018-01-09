pragma solidity ^0.4.18;

library Structs {

    struct Bounty {
        address creator;
        bytes32 targetName;
        string targetDescription;
        uint reward;

        uint postedOn;

        address fulfiller;
        bytes32 fulfillerNickname; //optional. In case the bounty hunter that fulfilled this wants to market their name.
        bool fulfilled;
    }

}