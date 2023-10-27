// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {BUBDAO} from "../src/617DAO.sol";

contract DAOTest is Test {
   BUBDAO public dao;

   function setUp() public {
      dao = new BUBDAO(address(dao));
   }

   function test_addMember() public {
      dao.addMember(address(0));
      assertEq(dao.balance(address(0)), 1);
   }

   function test_addVP() public {
      dao.addVP(address(0));
      assertEq(dao.balance(address(0)), 2);
   }

   function test_addProposals() public {
      vm.prank(address(0));
      dao.addMember(address(0));
      vm.prank(address(0));
      dao.addProposal("test");
      (string memory proposal,,) = dao.proposals(0);
      assertEq(proposal, "test");
   }

   function test_vote() public {
      vm.prank(address(0));
      dao.vote(0, true);
      (,uint256 votesYa,) = dao.proposals(0);
      assertEq(votesYa, 1);
   }

   function test_votePassed() public {
    dao.addProposal("test2");
    //bytes32 proposalId = keccak256(abi.encodePacked("test2"));
    vm.prank(address(0));
    dao.vote(1, true);
    vm.expectEmit();
   }
   
   /* BUBDAO public counter;

    function setUp() public {
        counter = new BUBDAO();
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }*/
}
