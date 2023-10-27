// SPDX-License-Identifier: CC-BY-1.0
pragma solidity 0.8.20;

//@title The Boston University Blockchain Club DAO
//@author Wes Jorgensen, @Wezabis on twtr
//@notice This contract is a simple DAO for the Boston University Blockchain Club

contract BUBDAO {
    
    //Set to BUB Wallet Address
    address public owner;

    mapping (address => uint) public balance;
    address private president;
    uint private totalTokens;

    uint8 constant TOTAL_PRESIDENT_TOKENS = 3;
    uint8 constant TOTAL_VP_TOKENS = 2;
    uint8 constant TOTAL_MEMBER_TOKENS = 1;

    error Unauthorized();
    error AlreadyMember();
    error MeetingNotOpen();
    error MeetingIsAlreadyOpen();
    error alreadyCheckedIn();
    
    struct Proposal {
        string proposal;
        uint votesYa;
        uint votesNay;
    }

    struct Meeting {
        uint date;
        string topic;
        address[] attendees;
        bool open;
    }

    Meeting private currentMeeting;
    Meeting[] private pastMeetings;

    mapping (address => uint) private notYetMembers;
    uint8 constant MEETINGS_REQUIRED_TO_JOIN = 3;

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
        balance[msg.sender] = TOTAL_PRESIDENT_TOKENS;
        totalTokens += TOTAL_PRESIDENT_TOKENS;
    }

    //All adding and removing members functions

    //@notice adds members to DAO
    function addMember(address _member) public onlyOwner {
        if(balance[_member] != 0){
            revert AlreadyMember();
        }
        balance[_member] = TOTAL_MEMBER_TOKENS;
        totalTokens += TOTAL_MEMBER_TOKENS;
    }

    //@notice adds VP to DAO
    function addVP(address _vp) public onlyOwner {
        if(balance[_vp] == 1){
            balance[_vp] = TOTAL_VP_TOKENS;
            totalTokens += TOTAL_VP_TOKENS;
        }
        else{
            revert Unauthorized();
        }
    }

    //@notice adds President to DAO and removes old president
    function newPresident(address _president) public onlyPresident {
        balance[_president] = TOTAL_PRESIDENT_TOKENS;
        balance[president] = 0;
        president = _president;
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

    //@notice removes members from DAO
    function removeMember(address _member) public onlyOwner {
        balance[_member] = 0;
        totalTokens -= TOTAL_MEMBER_TOKENS;
    }

    function removeVP(address _vp) public onlyOwner {
        balance[_vp] = 0;
        totalTokens -= TOTAL_VP_TOKENS;
    }


    //Proposals and voting

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


    //Check-in functions

    function newMeeting(string calldata topic) public onlyPresident {
        if(currentMeeting.open){
            revert MeetingIsAlreadyOpen();
        }
        
        address[] memory attendees;
        currentMeeting = Meeting(block.timestamp, topic, attendees, true);
    }

    function checkIn() public {
        if(!currentMeeting.open){
            revert MeetingNotOpen();
        }
        
        //Parse through current meeting attendees to see if address has already checked in
        if(currentMeeting.attendees.length > 0){
            for(uint i = 0; i < currentMeeting.attendees.length; i++){
                if(currentMeeting.attendees[i] == msg.sender){
                    revert alreadyCheckedIn();
                }
            }
        }

        if(balance[msg.sender] < 1){
            notYetMembers[msg.sender] += 1;

            if(notYetMembers[msg.sender] >= MEETINGS_REQUIRED_TO_JOIN){
                addMember(msg.sender);
                delete notYetMembers[msg.sender];
            }
        }

        currentMeeting.attendees.push(msg.sender);
    }

    function closeMeeting() public onlyPresident {
        currentMeeting.open = false;
        pastMeetings.push(currentMeeting);
    }


}