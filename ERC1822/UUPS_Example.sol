// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {UUPSUpgradeable} from "https://github.com/aloycwl/Proxy.sol/blob/main/ERC1822/UUPS.sol"; 

contract NFTExample is UUPSUpgradeable {

    uint public totalSupply;
    string public name;

    function initialize(uint totalSupply_) external {
        init();
        (totalSupply, name) = (totalSupply_, "Crazy NFT");
    }

    function mint() external virtual {
        require(--totalSupply > 0x01, "Ran out of supply");
    }
}

contract NFTExampleV2 is NFTExample {

    uint constant public NFTVersion = 0x02;

    constructor() {
        name = "Wild NFT";
    }

    function addSupply() external {
        totalSupply += 0x0f;
    }

    function mint() external override {
        require(--totalSupply > 0x00, "Ran out of supply");
    }
}