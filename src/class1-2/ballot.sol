// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/// @title Ballot
/// @dev implements voting process along with vote delegation

contract Ballot {

    //struct is like an object
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    //struct is like an object
    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    //the chairperson-כתובת יושב ראש
    address public chairperson;

    //like a dictionary -address, value 
    mapping(address => Voter) public voters;

    //an array of Proposals (struct)
    Proposal[] public proposals;

    //the constructor get array of proposals
    constructor(bytes32[] memory proposalNames) {
        //put the caller into the chairperson
        chairperson = msg.sender;
        //put in the weight's chairperson - 1
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            //put all the proposals to the array
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    
    function giveRightToVote(address voter) public {
        //check if the caller is the chairperson
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        //check if the voter already voted
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        //check if the voter have the right to vote
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function delegate(address to) public {
        //put the current voter into sender
        //what does the 'storage' mean
        Voter storage sender = voters[msg.sender];

        //check if the voter already voted
        require(!sender.voted, "You already voted.");

        //check if the voter doesn't vote to himself
        require (to != msg.sender, "Self-delegation is disallowed.");

        //
        while(voters[to].delegate != address(0)) {
            //change 'to' to his delegate 
            to = voters[to].delegate;
            require(to != msg.sender, "Found loop in delegation.");
        }
        //update the sender to - voted
        sender.voted = true;
        //update the delegate to 'to'
        sender.delegate = to;
        
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            //check if the delegate voted
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {

            delegate_.weight += sender.weight;
        }
    }


    function vote(uint proposal) public {
        //put the caller into sender
        Voter storage sender = voters[msg.sender];

        //check if the caller has right to vote
        require(sender.weight != 0, "Has no right to vote");

        //check if the caller already voted
        require(!sender.voted, "Already voted.");

        //change the 'voted' of the caller to 'true'
        sender.voted = true;

        //change the 'voted' of the caller to 'true'
        sender.vote = proposal;

        proposals[proposal].voteCount +=sender.weight;
    }

    //the function returns the index of winner proposal
    function winningProposal() public view returns(uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            //if count that choose this proposal bigger
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }      
    }

    //return the name of proposal that win
    function winnerName() public view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
