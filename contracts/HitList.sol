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
    mapping(uint => uint) private bountyReleaseKeys;

    //Random number generator
    Random private random;

    //    Creates a HitList with a given title that collects and sends a certain percentage of all bounty fulfillments to the list owner's address. Kaching!.
    function HitList(bytes32 title, uint fee) public {
        listTitle = title;
        listFee = fee;
        listOwner = msg.sender;


        escrow = 0;

        random = Random(this);
    }

    //Anyone can create a bounty
    function createBounty(bytes32 targetName, string targetDescription, uint reward) public payable returns (uint){

        uint bountyId = numBounties++;

        //TODO: collect reward money (for escrow) AND fee (for revenue)
        //Payment value must be large enough to cover reward and listFee
        require(msg.value > reward + listFee);
        //        msg.sender.transfer(reward);

        uint releaseKey = random.random(6);
        bounties[bountyId] = Structs.Bounty(msg.sender, targetName, targetDescription, reward, now, 0, 0, false);
        bountyReleaseKeys[bountyId] = releaseKey;

        return releaseKey;
    }

    //Get all bounties
    //FUTURE: Implement pager
    function getBounties() public view returns (Structs.Bounty[]){

        return bounties;
    }

    function getBounty(uint bountyId) public view returns (Structs.Bounty){

        return bounties[bountyId];
    }

    function getBountyTargetName(uint bountyId) public view returns (bytes32){

        return bounties[bountyId].targetName;
    }

    // Release a bounty's ethPrice to the sender of this mesage, if they have the right key.
    function fulfillBounty(uint bountyId, uint64 releaseKey, bytes32 nickname) public returns (bool){

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
