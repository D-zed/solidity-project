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

    address[] public votedVoters;
    address[] public votersAddress;

    struct Voter{
        uint256 voter_Id;
        string name;
        string image;
        address _address;
        uint256 voter_allowed;
        bool voter_voted;
        //投票的候选人id
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
    mapping(address=>Voter) public voters;

    constructor(){
        votingOrganizer=msg.sender;
    }

    function setCandidate(
        string calldata _name, 
        string calldata _image, 
        string calldata _age , 
        string calldata _ipfs,
        address _address) external {
        require(votingOrganizer == msg.sender,"only organization");
        _candidatedId.increment();
        //候选人id
        uint idNumber=_candidatedId.current();
        //候选人信息
        Candidate storage candidate=candidates[_address];
        candidate.candidatedId=idNumber;

        candidate.age=_age;
        candidate.image=_image;
        candidate.name=_name;
        candidate.voteCount=0;
        candidate._ipfs = _ipfs;
        candidate._address=_address;
        candidates[_address]=candidate;
        candidateAddress.push(_address);
        emit CandidateCreate(
                  idNumber,
                 _age,
                _name,
                _image,
                0,
                _address,
                _ipfs
             );
    }

    function getCandidate() external view returns(address[] memory ){
        return candidateAddress;
    }

    // 候选人数
    function getCandidatesLength() external view  returns (uint) {
        return _candidatedId.current();
    }

    function getCandidate(address _address) external view returns(
        string memory ,//_age , 
        string memory ,//_name, 
        string memory ,//_image, 
        string memory //_ipfs 
        ,uint256 //candidatedId
        ,uint256 //vote count
        ,address //候选人地址
    ){
        /*
         uint256 candidatedId,
        string age,
        string name,
        string image,
        uint256 voteCount,
        address _address,
        string _ipfs
        */
        Candidate storage candidate= candidates[_address];
        return (
            candidate.age,
            candidate.name,
            candidate.image,
            candidate._ipfs,
            candidate.candidatedId,
            candidate.voteCount,
            candidate._address
        );
    }

    function voterRight(
        address _address,
        string calldata _name,
        string calldata _image,
        string calldata _ipfs
        ) public {
        require(votingOrganizer==msg.sender,"only organization");
        _voterId.increment();
        uint256 idNumber=_voterId.current();
        Voter storage voter=voters[_address];
        voter.voter_Id=idNumber;
        voter.name=_name;
        voter.image=_image;
        voter._address=_address;
        voter.voter_allowed=1;
        voter.voter_voted=false;
        voter.voter_vote=1000;
        voter.voter_ipfs=_ipfs;

        votersAddress.push(_address);

        emit  VoterCreate(
        voter.voter_Id,
        voter.name,
        voter.image,
        voter._address,
        voter.voter_allowed,
        voter.voter_voted,
        voter.voter_vote,
        voter.voter_ipfs
        );
    }

    function vote(address _candidateAddress,uint _candidatedVodeId) external {
        Voter storage voter= voters[msg.sender];
        require(!voter.voter_voted,"you hava already voted!");
        require(voter.voter_allowed != 0,"please check your vote rights");
        voter.voter_voted=true;
        voter.voter_vote=_candidatedVodeId;
        votedVoters.push(msg.sender);

        candidates[_candidateAddress].voteCount += voter.voter_allowed;


    }

    function getVoterLength()public view returns(uint256){
        return votersAddress.length;
    }

    function getVoterData(address _address) public view returns(
        uint256 //voter_Id,
        ,string memory//name,
        ,string memory //image,
        ,address //_address,
        ,uint256 //voter_allowed,
        ,bool //voter_voted,
        ,uint256 //voter_vote,
        ,string memory //voter_ipfs
    ){
        Voter storage voter= voters[_address];
       return( 
            voter.voter_Id,
            voter.name,
            voter.image,
            voter._address ,// address of the voter 
            voter.voter_allowed ,
            voter.voter_voted,
            voter.voter_vote,
            voter.voter_ipfs);
    }
    
    function getVotedVotersList() public view returns (address[] memory){
        return votedVoters;
    }

    function getVoterList() public view returns (address[]memory){
        return votersAddress;
    }
}