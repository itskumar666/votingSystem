// SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

contract Voting{

    struct Candidate{
        uint id;
        string name;
        uint voteCount;
    }
    struct Voter{
        bool voted;
        uint CandidateId;
    }

    address public admin;
    uint public candidateCount;
    uint public voterCount;
    bool public votingActive;

    mapping(address => Voter)public voters;
    mapping (uint => Candidate)public candidates;


    event Voted(address indexed voter, uint candidateId);
    event VotingStarted();
    event VotingEnded();
    event candidateAdded(uint candidateId,string name);
    modifier onlyAdmin{
        require(msg.sender==admin,"Only admin can add new A NEW CANDIDATE");
        _;
    }
   constructor (){
    admin=msg.sender;
   }
    function addCandidte(string memory _name)public onlyAdmin{
        candidateCount++;
        candidates[candidateCount]=Candidate(candidateCount,_name,0);
        emit candidateAdded(candidateCount, _name);
    }
  
    function votingStart()public onlyAdmin{
        votingActive=true;
        emit VotingStarted();
    }
     function votingEnded()public onlyAdmin{
        votingActive=false;
        emit VotingEnded();
    }
    function vote(uint _candidateId) public{
        require(votingActive==true,"Voting is not started");
        require(!voters[msg.sender].voted,"You have already voted");
        require(_candidateId>0 && _candidateId<=candidateCount,"Invalid CandidateID");

        voters[msg.sender]=Voter(true,_candidateId);
        candidates[_candidateId].voteCount++ ;

        emit Voted(msg.sender, _candidateId);

    }
    function getWinner() public view returns(string memory){
        require(!votingActive,"Voting is still going on");
         uint maxVotes = 0;
        uint winningCandidateId;

        for (uint i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }

        return candidates[winningCandidateId].name;

    }


}