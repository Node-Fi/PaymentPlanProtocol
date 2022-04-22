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

    function testFailCreateNoApproval() public {
        // Test trying to create a payment plan without approving the full amount
        payments.createPaymentPlan(address(this), address(token), 1000, 5, 1 days);
    }

    function testCreatePlan() public {
        uint256 numIntervals = 5;
        uint256 amountPerInterval = 1000;
        token.approve(address(payments), numIntervals * amountPerInterval);
        payments.createPaymentPlan(address(this), address(token), amountPerInterval, numIntervals, 1 days);
        PaymentStructures.PaymentSchedule memory plan = payments.getPaymentDetails(1);
        assert(plan.totalIntervals == numIntervals);
        assert(plan.amountPerInterval == amountPerInterval);
        assert(plan.nextTransferOn > block.timestamp);
    }
}
