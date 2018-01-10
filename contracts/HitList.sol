pragma solidity ^0.4.18;

import "eth-random/contracts/Random.sol";
import "./Structs.sol";

contract HitList {

    bytes32 private listTitle;
    address private listOwner;

    // All Monetary units are in wei
    uint private listFee; // This is what we charge to create a bounty on our list
    uint private escrow; // This is where funds are held upon completion of bounties
    uint private revenue; // This is what we calculate so far as the money we have made from the HitList platform. TODO: can be a contract all its own with an address

    // Bounties
    uint private numBounties;
    Structs.Bounty[] private  bounties;
    mapping(uint => bytes32) private bountyReleaseKeys;

    //Random number generator
    Random private random;

    //events
    event bountyBeforeCreate(uint bountyId);
    event BountyCreated(uint bountyId, bytes32 targetName);
    event bountyFulfilled(uint bountyId, bytes32 targetName);

    //    Creates a HitList with a given title that collects and sends a certain percentage of all bounty fulfillments to the list owner's address. Kaching!.
    //    function HitList(bytes32 title, uint fee) public {
    //        listTitle = title;
    //        listFee = fee;
    //        listOwner = msg.sender;
    //
    //
    //        escrow = 0;
    //
    //        random = Random(this);
    //    }

    //Anyone can create a bounty
    function createBounty(bytes32 targetName, bytes32 targetDescription, uint reward) public returns (uint, bytes32){

        uint bountyId = numBounties++;

        bountyBeforeCreate(bountyId);

        //TODO: collect reward money (for escrow) AND fee (for revenue)
        //Payment value must be large enough to cover reward and listFee
        //        require(msg.value > reward + listFee);
        //        msg.sender.transfer(reward);

        bytes32 releaseKey = "releaseTheKraken";
        //TODO: generate this
        //        log0(releaseKey);
        bounties[bountyId] = Structs.Bounty(msg.sender, targetName, targetDescription, reward, now, 0, 0, false);
        bountyReleaseKeys[bountyId] = releaseKey;

        BountyCreated(bountyId, targetName);

        return (bountyId, releaseKey);
    }

    //Get all bounties
    function getBounties() public view returns (uint[] bountyIds, bytes32[] targetNames, bytes32[] targetDescriptions, uint[] postedTimestamps, bool[] fulfilleds){

        //TODO: Implement paging!
        for (uint i = 0; i < numBounties; i++) {
            bountyIds[i] = i;
            targetNames[i] = bounties[i].targetName;
            targetDescriptions[i] = bounties[i].targetDescription;
            postedTimestamps[i] = bounties[i].postedTimestamp;
            fulfilleds[i] = bounties[i].fulfilled;

        }
    }

    function getBounty(uint bountyId) public view returns (uint, bytes32, bytes32, uint, uint, bool){

        return (bountyId, bounties[bountyId].targetName, bounties[bountyId].targetDescription, bounties[bountyId].reward, bounties[bountyId].postedTimestamp, bounties[bountyId].fulfilled);
    }

    function getBountyTargetName(uint bountyId) public view returns (bytes32){

        return bounties[bountyId].targetName;
    }

    // Release a bounty's ethPrice to the sender of this mesage, if they have the right key.
    function fulfillBounty(uint bountyId, bytes32 releaseKey, bytes32 nickname) public returns (bool){

        if (bountyReleaseKeys[bountyId] != releaseKey) {
            return false;
        }

        //It's the right key so Release funds to sender
        Structs.Bounty storage bounty = bounties[bountyId];

        //Send money to bounty hunter
        msg.sender.transfer(bounty.reward);

        bounty.fulfiller = msg.sender;
        bounty.fulfillerNickname = nickname;
        bounty.fulfilled = true;
        bounties[bountyId] = bounty;
        return true;
    }


}
