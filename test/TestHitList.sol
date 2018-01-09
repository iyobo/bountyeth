pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HitList.sol";
import "../contracts/Structs.sol";

contract TestHitList {

    function testItCreatesABounty() public {
        HitList hitList = HitList(DeployedAddresses.HitList());

        uint releaseKey = hitList.createBounty("The Joker", "Dresses like a clown and likes to rob banks", 950);

        // assertions
        //Waiting for https://github.com/ethereum/solidity/pull/3272 to memorize returned struct
        bytes32 targetName = hitList.getBountyTargetName(0);
        Assert.equal(targetName, "The Joker", "targetName should be 'The Joker'");

    }

}
