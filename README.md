# PaymentPlanProtocol

## How to Use

### Creating a payment plan

1. Approve the payment plan contract as the spender for the total amount to be sent. `token.approve(address(paymentPlanContract), totalAmount)`
2. Create a payment plan by calling `createPaymentPlan(address target, address token, uint256 amountPerInterval, uint256 totalIntervals, uint256 intervalLength)`
   - target is the recipient of payments
   - token is the token to be used for payments
   - amountPerInterval is the total amount to be transfered per interval
   - totalInverals is the total number of intervals for the payment plan
   - intervalLength is the number of seconds that each interval will be
3. When a payment plan is started, an event is emitted to notify off-chain integrators.

### Fulfilling an interval

When a new interval begins for a payment plan, an event is emitted specifying the exact unix timestamp when a payment can be facilitated.
For off-chain integrators, all that is needed to initiate a payment is the plan id. Payment initiations can be batched together, as well.
When an interval is fulfilled, an event is fired so that offchain integrators know to stop tracking it.

### Canceling a payment plan

1. Revoke approval for the payment plan contract `token.approve(address(paymentPlanContract), 0)`
2. Retrieve the payment plan id
3. Call `cancelPaymentPlan(uint256 id)`

## Testing

### Install foundry

1. `curl -L https://foundry.paradigm.xyz | bash`
2. `source ~/[.zshrc | .bashrc | .bash_profile | .zsh_profile]`
3. `foundryup`

### Compile

`forge build`

### Test

`forge test`
