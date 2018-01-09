pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HitList.sol";
import "../contracts/Structs.sol";

contract TestHitList {

    function testItCreatesABounty() public {
        HitList hitList = HitList(DeployedAddresses.HitList());

        var (bountyId, passkey) = hitList.createBounty("The Joker", "http://bit.ly/xxxx", 950);

        // assertions
        //Waiting for https://github.com/ethereum/solidity/pull/3272 to memorize returned struct
        Assert.equal(bountyId, 1, "Bounty Id should be 1");
        Assert.notEqual(passkey, 0, "release key must not be null");

    }

}
