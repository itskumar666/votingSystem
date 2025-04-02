//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {Test,console} from 'forge-std/Test.sol';
import {Voting} from "../src/Voting.sol";

contract VotingTest is Test{

    Voting public voting;
    address public voter1=vm.addr(1);
        address public voter2 = address(0x456);
            address public voter3 = address(0x457);




    function setUp()public{
      voting = new Voting();
    }
    function testAdminCanAddCandidates() public{
      voting.addCandidte("Ashutosh");
      (uint id, string memory name,uint voteCount)=voting.candidates(1);
      assertEq(id,1);
      assertEq(name,"Ashutosh");
      assertEq(voteCount,0);
    }
    function testOnlyAdminCanAddCandidates()public{
       vm.prank(voter1);
       console.log(voter1);
       console.log("this is revert message");
       vm.expectRevert("Only admin can add new A NEW CANDIDATE");
       voting.addCandidte("Pragya");
    }
    function testVotingStarted()public{
      voting.votingStart();
      assertEq(voting.votingActive(),true);
    }
    function testVotingEnded()public{
      voting.votingEnded();
      assertEq(voting.votingActive(),false);
    }
    function testOnlyAdminCanStartVoting() public{
      vm.prank(voter1);
      vm.expectRevert("Only admin can add new A NEW CANDIDATE");
      voting.votingStart();
    }
    function testOnlyAdminCanEndVoting()public{
      vm.prank(voter1); 
      vm.expectRevert("Only admin can add new A NEW CANDIDATE");
      voting.votingEnded();
    }
    function testVotingProcess()public{
       voting.addCandidte("Ashutosh");
       voting.votingStart();
       vm.prank(voter1);
       voting.vote(1);
       (bool hashVoted,uint candidateId)=voting.voters(voter1);
       assertTrue(hashVoted);
       assertEq(candidateId,1);
       (uint id,string memory name,uint voteCount)=voting.candidates(1);
       assertEq(voteCount,1);
    }
    function testCannotVoteBeforeVotingStart()public{
      voting.addCandidte("Ashu");
      vm.prank(voter1);
      vm.expectRevert("Voting is not started");
      voting.vote(1);
    }
    function testGetWinner()public{
      voting.addCandidte("Pragya");
      voting.addCandidte("Ashu");
      voting.votingStart();
      vm.prank(voter1);
      voting.vote(1);
      vm.prank(voter2);
      voting.vote(1);
      vm.prank(voter3);
      voting.vote(2);
      voting.votingEnded();
      string memory winner=voting.getWinner();
      assertEq(winner,"Pragya");
   

    }
    

}