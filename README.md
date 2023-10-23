# Boston University Blockchain Club DAO

**Author:** Wes Jorgensen ([@Wezabis on Twitter](https://twitter.com/Wezabis))

This contract serves as a simple DAO for the Boston University Blockchain Club.

## Contract Functions

### Modifiers:
- **onlyOwner**: Ensures that the caller is the owner of the contract.
- **onlyMember**: Ensures that the caller is a member of the DAO.
- **onlyVP**: Ensures that the caller is a VP of the DAO.
- **onlyPresident**: Ensures that the caller is the president of the DAO.

### Core Functions:

- **constructor(address _president)**: Sets the owner and president of the DAO.
  
- **addMember(address _member)**: Adds a member to the DAO.
  
- **addVP(address _vp)**: Adds a VP to the DAO.
  
- **newPresident(address _president)**: Appoints a new president to the DAO and removes the old president.
  
- **removeMember(address _member)**: Removes a member from the DAO.
  
- **addProposal(string calldata _proposal)**: Allows a member to add a proposal.
  
- **vote(uint _proposal, boolean _vote)**: Allows a member to vote on a proposal. If a proposal receives more than half of the total votes in favor, it passes. If it receives more than half of the total votes against, it fails.
  
- **getProposal(uint _proposal)**: Returns the proposal and its votes (both in favor and against).
  
- **airdrop(address[] list)**: Airdrops governance tokens to a list of new members.
  
- **vpAirdrop(address[] list)**: Airdrops governance tokens for VPs to a list of new VPs.

### Events:

- **NewProposal**: Emitted when a new proposal is added.
  
- **proposalPassed**: Emitted when a proposal passes.
  
- **proposalFailed**: Emitted when a proposal fails.

---
