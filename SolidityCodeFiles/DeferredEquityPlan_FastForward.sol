pragma solidity ^0.5.0;

// lvl 3: equity plan
contract DeferredEquityPlan {
    
    address human_resources;
    
    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract
    
    // FOR TESTING: Reduced the total_shares to 100 & annual_distribution to 25 - Limited testing Ether
    uint total_shares = 100; // Set the total shares
    uint annual_distribution = 25;  // Set the annual distribution
    
    // FOR TESTING: Added fakenow as substitute for now
    uint fakenow = now; // Set the now to fakenow
    
    uint start_time = fakenow; // permanently store the time this contract was initialized
    uint unlock_time = fakenow + 365 days; // Set the `unlock_time` to be 365 days from now
    
    uint public distributed_shares; // starts at 0

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }
    
    // FOR TESTING: Create function to test dates
    function fastforward() public {
        fakenow += 100 days; // first run fakenow
    // fakenow += 366 days; // second-fourth run fakenow
        }

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");
        // Add "require" statements to enforce that:
        require(unlock_time <= fakenow, "Account is locked!"); // 1: `unlock_time` is less than or equal to `now`
        require(distributed_shares < total_shares, "No more shares to distribute."); // 2: `distributed_shares` is less than the `total_shares`

        unlock_time += 365 days; // Add 365 days to the `unlock_time`

        distributed_shares = (fakenow - start_time) / 365 days * annual_distribution; // Calculate the shares distributed by using the function (now - start_time) / 365 days * the annual distribution

        // double check in case the employee does not cash out until after 5+ years
        if (distributed_shares > 100) {
            distributed_shares = 100;
        }
    }

    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}
