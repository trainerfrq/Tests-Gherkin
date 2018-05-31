Narrative:
As an operator initiating a group call towards a target role
I want to cancel the group call
So I can verify that the call alerting is terminated in all operator positions of the target role

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

Scenario: Op2 cancels group call
Then HMI OP2 cancels the call queue item Role1-OP2
Then waiting for 1 seconds
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is canceled for target operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls
