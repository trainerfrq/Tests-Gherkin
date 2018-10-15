Narrative:
As an operator
I want to establish many calls
So I can check that the call history list is time sorted

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                 | target                 | callType |
| OP2-OP1   | sip:222222@example.com | sip:111111@example.com | DA/IDA   |
| OP2-OP3   | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |
| OP2-Role1 | sip:222222@example.com | sip:role1@example.com  | DA/IDA   |

Scenario: Caller clears call history list
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 clears Call History list
Then HMI OP2 verifies that call history list contains 0 entries
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes an outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP1 has the DA key OP2(as OP1) in state ringing

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP1

Scenario: Caller establishes an another outgoing call
When HMI OP2 presses DA key OP3
Then HMI OP2 has the DA key OP3 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP3 has the DA key OP2(as OP3) in state ringing

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP3

Scenario: Caller establishes an outgoing call towards Role1 as OP2
When HMI OP2 presses DA key ROLE1(as OP2)
Then HMI OP2 has the DA key ROLE1(as OP2) in state out_ringing

Scenario: Operators part of called role receive the incoming call
Then HMI OP1 has the call queue item OP2-Role1 in state ringing
Then HMI OP3 has the call queue item OP2-Role1 in state ringing

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1(as OP2)

Scenario: Verify call is terminated for all operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Caller opens call history
When HMI OP2 presses function key CALLHISTORY

Scenario: Caller verifies that call history entries are ordered by time
            @REQUIREMENTS:GID-3225206
Then HMI OP2 verifies that call history list contains 3 entries
Then HMI OP2 verifies call history list is time-sorted

Scenario: Caller closes call history
Then HMI OP2 closes Call History popup window
