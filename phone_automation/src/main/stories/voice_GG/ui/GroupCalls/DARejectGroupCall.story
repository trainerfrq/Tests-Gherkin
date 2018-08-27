Narrative:
As an operator being part of the target role of a DA call
I want to reject the DA call
So I can verify that the phone call is rejected on my operator position and the alerting is not terminated for the other operators
part of the same role

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                 | target                 | callType |
| OP2-Role1 | sip:222222@example.com | sip:role1@example.com  | DA/IDA   |
| Role1-OP2 | sip:role1@example.com  | sip:222222@example.com | DA/IDA   |

Scenario: Caller establishes an outgoing call towards Role1 as OP2
When HMI OP2 presses DA key ROLE1(as OP2)
Then HMI OP2 has the DA key ROLE1(as OP2) in state out_ringing
Then HMI OP2 has the call queue item Role1-OP2 in state out_ringing

Scenario: Operators part of called role receive the incoming call
Then HMI OP1 has the call queue item OP2-Role1 in state ringing
Then HMI OP3 has the call queue item OP2-Role1 in state ringing

Scenario: Op1 rejects incoming call
Then HMI OP1 rejects the waiting call queue item
Then waiting for 1 seconds
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Verify call is still ringing for Op3
Then HMI OP3 has the call queue item OP2-Role1 in state ringing

Scenario: Op3 accept incoming call
Then HMI OP3 accepts the call queue item OP2-Role1
Then HMI OP3 has the call queue item OP2-Role1 in state connected

Scenario: Caller operator has the call in connected state
Then HMI OP2 has the call queue item Role1-OP2 in state connected

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1(as OP2)

Scenario: Call is terminated on both positions
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls