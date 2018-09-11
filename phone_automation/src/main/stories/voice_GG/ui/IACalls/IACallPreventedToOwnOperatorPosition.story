Narrative:
As a user caller operator
I want to initiate an outgoing IA call to own operator position
So I can verify that the operator doesn't have an incoming call.

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Caller establishes an outgoing IA call
When HMI OP2 presses IA key IA - OP2

Scenario: Verify call is received and call status is failed
		  @REQUIREMENTS:GID-2535698
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the IA key IA - OP2 in state out_failed

Scenario: Caller clears outgoing call
When HMI OP2 presses IA key IA - OP2

Scenario: Call is terminated
Then HMI OP2 has in the call queue a number of 0 calls