// SPDX-License-Identifier: CC-BY-1.0
pragma solidity 0.8.20;

//@title The Boston University Blockchain Club DAO
//@author Wes Jorgensen, @Wezabis on twtr
//@notice This contract is a simple DAO for the Boston University Blockchain Club

contract BUBDAO {
    
    //Set to BUB Wallet Address
    address public owner;

    mapping (address => uint) private balance;
    address private president;
    uint private totalTokens;
    uint totalMembers = 0;

    error Unauthorized();
    
    struct Proposal {
        string proposal;
        uint votesYa;
        uint votesNay;
    }

    Proposal[] public proposals;

    event NewProposal(string proposal);
    event proposalPassed(string proposal);
    event proposalFailed(string proposal);
    
    modifier onlyOwner() {
        if(msg.sender != owner){
            revert Unauthorized();
        }
        _;
    }

    modifier onlyMember() {
        if(balance[msg.sender] < 1){
            revert Unauthorized();
        }
        _;
    }

    modifier onlyVP() {
        if(balance[msg.sender] < 2){
            revert Unauthorized();
        }
        _;
    }

    modifier onlyPresident() {
        if(balance[msg.sender] < 3){
            revert Unauthorized();
        }
        _;
    }

    //@notice Constructor sets the owner and president of the DAO
    constructor(address _president) {
        owner = msg.sender;
        president = _president;
        ++totalMembers;
    }

    //@notice adds members to DAO
    function addMember(address _member) public onlyOwner {
        balance[_member] = 1;
        ++totalMembers;
    }

    //@notice adds VP to DAO
    function addVP(address _vp) public onlyOwner {
        require(balance[_vp] == 1);
        balance[_vp] = 2;
    }

    //@notice adds President to DAO and removes old president
    function newPresident(address _president) public onlyPresident {
        balance[_president] = 3;
        balance[president] = 0;
        president = _president;
    }

    //@notice removes members from DAO
    function removeMember(address _member) public onlyOwner {
        balance[_member] = 0;
        --totalMembers;
    }

   function addProposal(string calldata _proposal) public onlyMember {
        proposals.push(Proposal(_proposal, 0, 0));
        emit NewProposal(_proposal);
    }

    //@notice votes on a proposal
    function vote(uint _proposal, bool _vote) public onlyMember {
        //Adds vote
        if(_vote){
            proposals[_proposal].votesYa = ++proposals[_proposal].votesYa;
        } else {
            proposals[_proposal].votesNay = ++proposals[_proposal].votesNay;
        }
        
        //Checks if proposal passed
        if (proposals[_proposal].votesYa > totalTokens / 2) {
            emit proposalPassed(proposals[_proposal].proposal);
        }
        else if(proposals[_proposal].votesNay > totalTokens / 2) {
            emit proposalFailed(proposals[_proposal].proposal);
            delete proposals[_proposal];
        }
    }

    //@notice returns the proposal and votes for a given proposal
    //@return proposal and votes ya and nay
    function getProposal(uint _proposal) public view returns (string memory, uint, uint) {
        return (proposals[_proposal].proposal, proposals[_proposal].votesYa, proposals[_proposal].votesNay);
    }

    //@notice airdrops governance tokens to a list of new members
    function airdrop(address[] calldata list) public onlyOwner {
        for (uint i = 0; i < list.length; ++i) {
            balance[list[i]] = 1;
        }
    }

    //@notice airdrops number tokens for VP to a list of new VPs
    function vpAirdrop(address[] calldata list) public onlyOwner {
        for (uint i = 0; i < list.length; ++i) {
            balance[list[i]] = 2;
        }
    }




}