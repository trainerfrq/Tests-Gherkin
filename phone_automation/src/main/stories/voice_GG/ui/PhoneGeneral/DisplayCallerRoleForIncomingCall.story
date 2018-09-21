Narrative:
As a caller operator
I want to initiate a phone call using an Role SIP URI towards a role other than mine
So I can verify that the caller identity for the incoming call is displayed.

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key              | source                 | target                      | callType |
| OP2-Role1        | sip:222222@example.com | sip:role1@example.com       | DA/IDA   |
| Role2-Role1      | sip:role2@example.com  | sip:role1@example.com       | DA/IDA   |
| OP2-Role1Alias   | sip:222222@example.com | sip:role1alias1@example.com | DA/IDA   |
| Role2-Role1Alias | sip:role2@example.com  | sip:role1alias1@example.com | DA/IDA   |

Scenario: Caller establishes an outgoing call towards Role1 as OP2
When HMI OP2 presses DA key ROLE1(as OP2)

Scenario: Operators part of called role receive the incoming call with caller identity
Then HMI OP1 has the call queue item OP2-Role1 in the waiting list with label OP2 Physical
Then HMI OP3 has the call queue item OP2-Role1 in the waiting list with label OP2 Physical

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1(as OP2)

Scenario: Caller establishes an outgoing call towards Role1 as Role2
When HMI OP2 presses DA key ROLE1(as ROLE2)

Scenario: Operators part of called role receive the incoming call with caller identity
Then HMI OP1 has the call queue item Role2-Role1 in the waiting list with label Role 2 (Bob)
Then HMI OP3 has the call queue item Role2-Role1 in the waiting list with label Role 2 (Bob)

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1(as ROLE2)

Scenario: Caller establishes an outgoing call towards Role1-Alias as OP2
When HMI OP2 presses DA key ROLE1-ALIAS(as OP2)

Scenario: Operators part of called role receive the incoming call with caller identity
Then HMI OP1 has the call queue item OP2-Role1Alias in the waiting list with label OP2 Physical
Then HMI OP3 has the call queue item OP2-Role1Alias in the waiting list with label OP2 Physical

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1-ALIAS(as OP2)

Scenario: Caller establishes an outgoing call towards Role1-Alias as Role2
When HMI OP2 presses DA key ROLE1-ALIAS(as ROLE2)

Scenario: Operators part of called role receive the incoming call with caller identity
Then HMI OP1 has the call queue item Role2-Role1Alias in the waiting list with label Role 2 (Bob)
Then HMI OP3 has the call queue item Role2-Role1Alias in the waiting list with label Role 2 (Bob)

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1-ALIAS(as ROLE2)

Scenario: Call is terminated for all three operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls