// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import { RecurringPayments, PaymentStructures } from "src/RecurringPayments.sol";
import { ERC20PresetFixedSupply } from "openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract ContractTest is DSTest {
    RecurringPayments payments;
    ERC20PresetFixedSupply token;
    RecurringPayments bogey;
    function setUp() public {
        payments = new RecurringPayments();
        bogey = new RecurringPayments();
        token = new ERC20PresetFixedSupply("Test", "TST", 10000000000000, address(this));
    }

    function _createPlan(uint256 numIntervals, uint256 amountPerInterval, uint256 intervalLength) internal {
        token.approve(address(payments), numIntervals * amountPerInterval);
        payments.createPaymentPlan(address(this), address(token), amountPerInterval, numIntervals, intervalLength);
    }

    function testFailCreateNoApproval() public {
        // Test trying to create a payment plan without approving the full amount
        payments.createPaymentPlan(address(this), address(token), 1000, 5, 1 days);
    }

    function testCreatePlan() public {
        uint256 numIntervals = 5;
        uint256 amountPerInterval = 1000;
        uint256 intervalLength = 1 days;
        _createPlan(numIntervals, amountPerInterval, intervalLength);

        PaymentStructures.PaymentSchedule memory plan = payments.getPaymentDetails(1);
        assert(plan.totalIntervals == numIntervals);
        assert(plan.amountPerInterval == amountPerInterval);
        assert(plan.nextTransferOn > block.timestamp);
    }

    function testFulfillPlanWithFuzzing(uint256 intervalLength) public {
        uint256 numIntervals = 5;
        uint256 amountPerInterval = 1000;
        _createPlan(numIntervals, amountPerInterval, intervalLength);
    }
}
