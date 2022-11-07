// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment the line to use openzeppelin/ERC20
// You can use this dependency directly because it has been installed already
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract StudentSocietyDAO {

    // use a event if you want
    event ProposalInitiated(uint32 proposalIndex);

    uint32 constant public Vote_Amount = 1;         //投票需要金额
    uint32 constant public Propose_Amount = 10;     //发起提案需要金额
    uint32 constant public Award_Amount = 20;       //提案通过奖励
    uint32 constant public Vote_Times = 3;          //同一个提案，一个学生最多只能投三次票
    uint32 constant public Proposal_Bonus = 3;      //提案成功超过3次，则可以获得纪念品

    struct Proposal {
        uint32  index;      // index of this proposal
        address proposer;  // who make this proposal
        uint256 startTime; // proposal start time
        uint256 duration;  // proposal duration
        string  name;       // proposal name
        uint32  approve;    //提案赞成数
        uint32  oppose;     //提案反对数
        bool    over;       //判断提案是否结束
    }
    
    //   ERC20 studentERC20;
    mapping(uint32 => Proposal) public proposals; // A map from proposal index to proposal
    
    // ...
    // TODO add any variables if you want
    
    //学生获取初始积分
    function getInitERC20() external returns(bool result){
        if(!Student[msg.sender].initiate){
            studentERC20.transfer(msg.sender, 100);
            studentERC20.allow(msg.sender, 100);
            students[msg.sender].initiate = true;
            return true;
        }
        else{
            return false;
        }
    }

    //创建提案
    function new_proposal(){
        studentERC20.transferFrom(msg.sender, address(this), Propose_Amount);
        proposalNum = proposalNum + 1;
        proposals[proposalNum].index = proposalNum;
        proposals[proposalNum].proposer = msg.sender;
        proposals[proposalNum].approve = (amount - proposalInitCost) / costPerVote;
        proposals[proposalNum].oppose = 0;
        proposals[proposalNum].startTime = block.timestamp;
        proposals[proposalNum].duration = duration;
        proposals[proposalNum].name = name;
        proposals[proposalNum].over = false;
        return;
    }

    
    //学生发起提案
    function initiate_proposa(Struct proposer) pure external returns(bool result){
    
    if (proposal.studentERC20<Propose_Amount){ 
    return false;                                                        //学生没有足够积分发起提案
    }        
    new_proposal();                                                      //创建新提案
    
    studentERC20.transferFrom(msg.sender, address(this), Propose_Amount);//发起成功，扣除积分
    return true;
    }

    //对提案进行投票
    function vote_propose(uint32 index,bool choice) pure external returns(bool result){
    if (block.timestamp > proposals[index].startTime && block.timestamp < proposals[index].startTime+proposal[index].duration){//获取提案并判断是否过期
    
    if(choice==true){                                                    //投赞成票
    studentERC20.transferFrom(msg.sender, address(this), Vote_Amount);
            proposals[index].approve++;
    }

    if(choice==false){                                                   //投反对票  
    studentERC20.transferFrom(msg.sender, address(this), Vote_Amount);
            proposals[index].oppose++;
    }
    
    return true;                                                           //学生投票成功，返回
    }
        else{
            return false;                                                  //提案过期，投票失败
        }
    }

    //提案通过对提出者进行奖励
    function award_porposer(student proposer){
                                                                            //对提出者进行积分奖励
        proposer.ERC20 += Award_Amount;
    }

    //判断学生能否获取纪念品
    function judge_souvenir(student proposer) pure external returns(bool result){                                        
        if(proposer.passProposal>=Proposal_Bonus) return true;  //若提案成功超过三次，则可以领取纪念品
        else retuen false;
    }
}

//提案结束，判断结果
function endProposal(uint32 index) external returns(bool result) {
        if (block.timestamp > proposals[index].startTime+proposal[index].duration) {
            proposals[index].over = true;
            if (proposals[index].approve > proposals[index].oppose) {
                // 奖励发起人20积分
                studentERC20.transfer(proposals[index].proposer,Award_Amount);
                studentERC20.allow(proposals[index].proposer, Award_Amount);
            }
            return true;
        } else {
            return false;
        }
    }

//获取所有提案
function getAllProposals() view external returns(Proposal[] memory) {
        Proposal[] memory result = new Proposal[](proposalIndex);
        for (uint32 i=0; i<proposalIndex; i++) {
            result[i] = proposals[i];
        }
        return result;
    }

//获取提案
    function getProposal(uint32 index) view external returns(Proposal memory) {
        return proposals[index];
    }
}



