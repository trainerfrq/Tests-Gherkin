Narrative:
As a caller operator having Call Forward active
I want to make an outgoing call from Call History
So I can verify that call can be done while Call Forward is active

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key        | source                 | target                 | callType |
| OP1-OP2-DA | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1-DA | sip:222222@example.com | sip:111111@example.com | DA/IDA   |
| OP1-OP2-IA | sip:111111@example.com | sip:222222@example.com | IA       |
| OP2-OP1-IA | sip:222222@example.com | sip:111111@example.com | IA       |

Scenario: Op1 activates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 is in forward_ongoing state

Scenario: Op1 chooses Op2 as call forward target
		  @REQUIREMENTS:GID-2521111
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 is in forward_active state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 clears call history list
When HMI OP1 presses function key CALLHISTORY
Then HMI OP1 clears Call History list
Then HMI OP1 verifies that call history list contains 0 entries
Then HMI OP1 closes Call History popup window

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP1 in state ringing

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 redials from CallHistory
When HMI OP1 presses function key CALLHISTORY
When HMI OP1 redials last number
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP1 in state ringing

Scenario: Op2 client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1-DA in state connected
Then HMI OP2 has the call queue item OP1-OP2-DA in state connected
Then HMI OP2 verifies that call queue item bar signals call state active

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 is in forward_active state

Scenario: Op1 establishes an outgoing priority call
When HMI OP1 initiates a priority call on DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP1 in state ringing
Then HMI OP2 has in the call queue the item OP1-OP2-DA with priority

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 redials from CallHistory
When HMI OP1 presses function key CALLHISTORY
When HMI OP1 redials last number
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Op2 client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1-DA in state connected
Then HMI OP2 has the call queue item OP1-OP2-DA in state connected
Then HMI OP2 verifies that call queue item bar signals call state priority

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 is in forward_active state
Then HMI OP1 verifies that call queue info container is visible

Scenario: Op1 establishes an outgoing IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has the call queue item OP2-OP1-IA in state connected
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected

Scenario: Op2 receives incoming IA call
Then HMI OP2 has the call queue item OP1-OP2-IA in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 redials from CallHistory
When HMI OP1 presses function key CALLHISTORY
When HMI OP1 redials last number
Then HMI OP1 has the call queue item OP2-OP1-IA in state connected
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected

Scenario: Op2 receives incoming IA call
Then HMI OP2 has the call queue item OP1-OP2-IA in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 is in forward_active state

Scenario: Op1 deactivates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible