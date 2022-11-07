// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

 struct Student{
        bool initiate;              //是否领取初始积分
        uint32 passProposal;        //通过提案数
}

contract SocietyCredit is ERC20 {

    mapping(address => bool) claimedAirdropStudent;
	//设置管理员
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
	studentERC20 = new ERC20("studentERC20", "STU");
       	manager = msg.sender;
    }
	//空投获取初始积分
    function airdrop() external {
        require(claimedAirdropStudent[msg.sender] == false, "This student has claimed airdrop already");
        _mint(msg.sender, 100);
        claimedAirdropStudent[msg.sender] = true;
    }

}
