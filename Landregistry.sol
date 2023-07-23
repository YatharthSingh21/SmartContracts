// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Landregistry{

    address Admin = msg.sender;
    enum Status { Forsale, Notforsale, underapproval, approved}

   
    struct Propertydetails{
        Status status;
		uint256 value;
		address currowner;
    }
    //mapping properties to their key which here is the propID which would allow us to use the details of properties.
    mapping (uint256 => Propertydetails) internal properties;

    //mapping integer to integer helping us to determine if a change of ownership is being agreed by both the parties
    //buyer and seller and then is approved by the admin.
    mapping(uint256 => uint256) internal ChangeOwner;

    //A mapping function allowing us ti seperate different entities of the network such as users, admin, etc.
    mapping(address => int) internal users;

    //Mapping address of users to a bool type data in order to define if a user is a verified user or not.
    mapping(address => bool) internal verifiedusers;

    //Creating an admin for the network
    function asset() internal {
		users[Admin] = 3;
		verifiedusers[Admin] = true;
	}


    //apply to be a user.
    function adduser(address _newuser) public{
        require(users[_newuser] == 0);
        require(verifiedusers[_newuser] == false);
        users[_newuser] = 1;
    }

    //approve the user.
    function approveuser(address _newuser) public{
        require(users[_newuser] != 0);
        require(msg.sender == Admin);
        verifiedusers[_newuser] = true;
    }

    //Function to create property.
    function createProperty(uint256 _propId, uint256 _value, address _owner) public{
        require(verifiedusers[_owner]==true);
		properties[_propId] = Propertydetails(Status.underapproval, _value, _owner);
	}

    //Function to approve the property that has been created.
    function approveproperty(uint256 _propID) public{
        require(msg.sender == Admin);
        properties[_propID].status = Status.approved; 
    }

    //Function to change the status of property that has been approved.
    function statusofpropertyforsale(uint256 _propID) public{
        require(verifiedusers[msg.sender] == true);
        require(properties[_propID].currowner == msg.sender);
        require(properties[_propID].status != Status.underapproval);
        properties[_propID].status = Status.Forsale;
    }

    function statusofpropertynotforsale(uint256 _propID) public{
        require(verifiedusers[msg.sender] == true);
        require(properties[_propID].currowner == msg.sender);
        require(properties[_propID].status != Status.underapproval);
        properties[_propID].status = Status.Notforsale;
    }

    //Request change of ownership from both the parties.

    //Change of ownership from the new owner's end.
    function Requestchangeofownership_new(uint256 _propID, address _newowner) public{
        require(verifiedusers[_newowner] ==  true);
        require(msg.sender == _newowner);
        require(ChangeOwner[_propID] == 1);
        ChangeOwner[_propID] += 1;
    }

    //Change of ownership from the old owner's end.
    function Requestchangeofownership_old(uint256 _propID, address _oldowner) public{       
        require(verifiedusers[_oldowner] ==  true);
        require(properties[_propID].status == Status.Forsale);
        require(properties[_propID].currowner == msg.sender);
        ChangeOwner[_propID] = 1;
    }

    //Approve the change in ownership by the admin.
    function approvechangeofownership(uint256 _propID, address _newowner) public{
        require(properties[_propID].status == Status.Forsale);
        require(ChangeOwner[_propID] == 2);
        properties[_propID].currowner = _newowner;
        ChangeOwner[_propID] = 0;
    }

    //Change value of ur property.
    function Changeofvalue(uint256 _propID, uint256 _newvalue) public{
        require(verifiedusers[msg.sender] ==  true);
        require(properties[_propID].currowner == msg.sender);
        require(properties[_propID].status != Status.underapproval);
        properties[_propID].value = _newvalue;
    }

    // Get the property details using propID.
    function getPropertyDetails(uint _propID) public view returns (Status _status, uint256 _value, address _currowner) {
		_status = properties[_propID].status;
        _value = properties[_propID].value;
        _currowner = properties[_propID].currowner;
	} 
}