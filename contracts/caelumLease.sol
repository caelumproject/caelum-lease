pragma solidity ^0.4.24;


contract CaelumInterface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


contract CaelumLease {

    struct LEASING {
        address leaser;
        address lender;
    }

    address public agreedToken = 0xf658B83456748EB784CB98F8F0786e1dAf8431B0;
    uint public agreedTimeframe = agreedTimeDays * 1 days;
    uint agreedTimeDays = 0;

    address public _leaser;
    address public _lender;

    modifier onlyLender () {
        require(msg.sender == _lender);
        _;
    }

    modifier onlyLeaser () {
        require(msg.sender == _leaser);
        _;
    }

    modifier bothParties () {
        require(msg.sender == _leaser  || msg.sender == _lender);
        _;
    }

    constructor() public {
        // REMOVE BEFORE LIVE!!! TESTING ONLY
        _lender = msg.sender;
        _leaser = msg.sender;

        //agreedTimeDays = _days;
    }

    // The lender calls this to approve the contract to become a masternode
    function approveMasternode () onlyLender public {
        if(!CaelumInterface(agreedToken).approve(0xf658b83456748eb784cb98f8f0786e1daf8431b0, 500000000000)) revert("nope");
    }

    // The lender can now start the masternode.
    function startMasternode () onlyLender public {
        CaelumInterface(agreedToken).depositCollateral(0xf658b83456748eb784cb98f8f0786e1daf8431b0, 500000000000);
    }

    // Both parties can check if the conditions have been met to close the contract.
    function verifyConditions () bothParties public {
        // Verify: Contract has all funds
        // Verify: Contract ran for the required time
        // Verify: Contract collected the agreed amount of tokens
        // Release all funds
    }

    // Release the accumulated tokens to the lender.
    function releaseTokensToLender ()  internal {
        if(!CaelumInterface(agreedToken).transfer(_lender, 0)) revert();
    }

    // Call this as last. The contract will self destruct and send all funds to the leaser
    function releaseFundsToLeaser ()  internal {
        if(!CaelumInterface(agreedToken).transfer(_leaser, 0)) revert();
        selfdestruct(_leaser);
    }


}
