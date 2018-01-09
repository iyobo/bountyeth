pragma solidity ^0.4.17;

import {Bounty} from "./Structs.sol";
import "eth-random/contracts/Random.sol";

contract HitList {

    byte32 private listTitle;
    uint private listFeePercentage;
    Address private listOwner;

    uint private numBounties;
    Bounty[] private  bounties;
    mapping(uint => uint64) private bountyReleaseKeys;

    //Random number generator
    Random private random;

    //Creates a HitList with a given title that collects and sends a certain percentage of all bounty fulfillments to the list owner's address. Kaching!.
    function HitList(byte32 title, uint feePercentage) {
        listTitle = title;
        listFeePercentage = feePercentage;
        listOwner = msg.sender;
        //

        random = Random(this);
    }

    //Anyone can create a bounty
    function createBounty(byte32 targetName, byte32 targetDescription, uint ethPrice) returns (uint){

        uint bountyId = numBounties++;

        uint releaseKey = random.random(6);
        bounties[bountyId] = Bounty(msg.sender, targetName, targetDescription, ethPrice);
        bountyReleaseKeys[bountyId] = releaseKey;

        return releaseKey;
    }

    //Get all bounties
    //TODO: Implement pager
    function getBounties() returns (Bounty[]){

        return bounties;
    }

    // Release a bounty's ethPrice to the sender of this mesage, if they have the right key.
    function fulfillBounty(uint bountyId, uint64 releaseKey, byte32 fulfillerName) returns (bool){

        if (bountyReleaseKeys[bountyId] != releaseKey) {
            return false;
        }

        //It's the right key so Release funds to sender
        Bounty bounty = bounties[bountyId];

        //TODO: send coins

        bounty.fulfiller = msg.sender;
        bounty.fulfillerName = true;
        bounty.fulfilled = true;
        bounties[bountyId] = bounty;
        return true;
    }


}
