// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";


contract Create{
    using Counters for Counters.Counter;

    Counters.Counter public _voterId;
    Counters.Counter public _candidatedId;

    address public votingOrganizer;

    struct Candidate{
        uint256 candidatedId;
        string age;
        string name;
        string image;
        uint256 voteCount;
        address _address;
        string _ipfs;
    }

    event CandidateCreate(
        uint256 candidatedId,
        string age,
        string name,
        string image,
        uint256 voteCount,
        address _address,
        string _ipfs
    );

    address [] public candidateAddress;

    mapping(address => Candidate) public candidates;

    address[] public votersAddress;

    struct voter{
        uint256 voter_Id;
        string name;
        string image;
        address _address;
        uint256 voter_allowed;
        bool voter_voted;
        uint256 voter_vote;
        string voter_ipfs;
    }

    event VoterCreate(
        uint256 voter_Id,
        string name,
        string image,
        address _address,
        uint256 voter_allowed,
        bool voter_voted,
        uint256 voter_vote,
        string voter_ipfs
    );
    mapping(address=>voter) public voters;

    constructor(){
        votingOrganizer=msg.sender;
    }

    function setCandidate(
        address _address,
        string memory name, 
        string memory image, 
        string memory age , 
        string memory ipfs ) external {

    }

}