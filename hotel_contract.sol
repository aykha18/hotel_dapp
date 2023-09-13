// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Hostel {

    address payable lanlord ;
    address payable tenant ;

    uint public no_of_rooms = 0;
    uint public no_of_agreement = 0;
    uint public no_of_rent = 0;

    struct Room{
        uint room_id;
        uint agreement_id;
        string room_name;
        string room_address;
        uint rent_pm;
        uint timestamp;
        uint security_deposit;
        bool vacant;
        address payable landlord;
        address payable current_tenant;
    }    

    mapping(uint => Room) public rooms_by_no;

    struct RoomAgreement{
        uint room_id;
        uint agreement_id;
        string room_name;
        string room_address;
        uint rent_pm;
        uint timestamp;
        uint security_deposit;
        uint lock_in_period;
        address payable landlord_address;
        address payable tenant_address;
    }

    mapping (uint => RoomAgreement) public RoomAgreement_ByNo;

    struct Rent{
        uint rent_id;
        uint room_id;
        uint agreement_id;
        string room_name;
        string room_address;
        uint rent_pm;
        uint timestamp;
        address payable landlord_address;
        address payable tenant_address;
    }

    mapping (uint => Rent) public rent_ByNo;

    modifier OnlyLandlord(uint _index){
        require(msg.sender == rooms_by_no[_index].landlord, "Only a Lanlord can Access this...");
        _;
    }

    modifier OnlyTenant(uint _index){
        require(msg.sender != rooms_by_no[_index].landlord, "Only a Tenant can access..");
        _;
    }

    modifier RoomRent(uint _index){
        require(msg.value >= rooms_by_no[_index].rent_pm,"Rent is Non-Negoitable");
        _;
    }

    modifier CheckAgreementFee(uint _index){
        uint tenant_wallet_balance = rooms_by_no[_index].rent_pm + 
        rooms_by_no[_index].security_deposit;
        require(msg.value >= tenant_wallet_balance , 
        "You wallet balance is insufficient for the the Agreement Amount ");
        _;
    }

    modifier CheckAgreementExpiry(uint _index){
        uint agreement_no = rooms_by_no[_index].agreement_id;
        uint time = RoomAgreement_ByNo[agreement_no].timestamp + RoomAgreement_ByNo[agreement_no].lock_in_period;
        require(block.timestamp < time, "There are still time left for tenant agreement Renewal");
        _;
    }

    function addRoom(string memory _room_name, string memory _room_address, uint _rent_cost,
                    uint _security_deposit) public {
        require(msg.sender != address(0));
        no_of_rooms++;


        rooms_by_no[no_of_rooms] = Room(no_of_rooms,
                                        0,
                                        _room_name,
                                        _room_address,
                                        _rent_cost,
                                        0,
                                        _security_deposit,
                                        90,
                                        msg.sender,
                                        address(0));
    }
}
