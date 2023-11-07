pragma solidity 0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {BUBDAO} from "../src/617DAO.sol";

contract Deploy617DAO is Script{
    function run() public {      
        vm.startBroadcast();
        new BUBDAO(address(0));
        vm.stopBroadcast();
    }
}