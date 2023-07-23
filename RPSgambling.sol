// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract poker{

    address payable[] players;
    uint256 totalETH;
    mapping (address => uint256) move;
    mapping (address => bool) public DiduwinETH;
    mapping (address => uint32) public ur_player_no;

    function Enter_with_1ether() public payable{
        require(players.length<2, "sorry the room is full try later");
        require(msg.value >= 1000000000000000000, "Enter with 1 ETher" );
        //require(msg.value==1);
        players.push(payable(msg.sender));
        DiduwinETH[msg.sender] =  false;
        if(players.length==1){
            ur_player_no[msg.sender] = 1;
        }
        else{
            ur_player_no[msg.sender] = 2;
        }
    }

    function Statusofroom() public view returns(bool can_I_enter_is) {
        if(players.length==2){
            return false;
        }
        else {
            return true;
        }
    }
    
    function playmove_1forrocks_2forpaper_3forscissor(uint256 value) public{
        require(DiduwinETH[msg.sender] ==  false);
        require(value < 4 && value > 0);
        move[msg.sender] = value;
    }

    function result_if_0_play_Again() public returns(uint32 Winner_is_player){
        if(move[players[0]]==1){
            if(move[players[1]]==1){
                return 0;
            }
            if(move[players[1]]==2){
                
                DiduwinETH[players[1]]=true; 
                return 2;
            }
            if(move[players[1]]==3){
                DiduwinETH[players[0]]=true;
                return 1;
            }
        }
    
        else if(move[players[0]]==2){
            if(move[players[1]]==1){
                DiduwinETH[players[0]]=true;
                return 1;
            }
            if(move[players[1]]==2){
                return 0;
            }
            if(move[players[1]]==3){    
                DiduwinETH[players[1]]=true; 
                return 2;
            }
        }
    
         else{
            if(move[players[1]]==1){
                
                DiduwinETH[players[1]]=true; 
                return 2;
            }
            if(move[players[1]]==2){
                DiduwinETH[players[0]]=true;
                return 1;
            }
            if(move[players[1]]==3){
                return 0;
            }
        }
    }

    function withdrawETH() public  payable {
        //require(msg.sender==players[winner-1], "You are not the winner");
        require(DiduwinETH[msg.sender]==true, "You are not the winner, pls check the result");
        payable(msg.sender).transfer(address(this).balance);

        DiduwinETH[players[0]] = false;
        DiduwinETH[players[1]] = false;
        move[players[0]] = 0;
        move[players[1]] = 0;
        delete players;
    }
}