Narrative:
As an operator
I want to change mission
So I can check that the call history list has the same entries

Meta: @AfterStory: ../includes/@SwitchToInitialMission.story

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

Scenario: Define call history entries
Given the following call history entries:
| key     | remoteDisplayName | callDirection | callConnectionStatus| duration    |
| entry0  | ROLE1(as OP2)     | outgoing      | not_established     | 00:00       |
| entry1  | OP3               | outgoing      | not_established     | 00:00       |
| entry2  | OP1               | outgoing      | not_established     | 00:00       |


Scenario: Caller clears call history list
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 clears Call History list
Then HMI OP2 verifies that call history list contains 0 entries
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes an outgoing call
When HMI OP2 presses DA key OP1
Then assign date time value for entry entry2
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP1 has the DA key OP2(as OP1) in state ringing

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP1

Scenario: Caller establishes an another outgoing call
When HMI OP2 presses DA key OP3
Then assign date time value for entry entry1
Then HMI OP2 has the DA key OP3 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP3 has the DA key OP2(as OP3) in state ringing

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP3

Scenario: Caller establishes an outgoing call towards Role1 as OP2
		  @REQUIREMENTS:GID-2886201
When HMI OP2 presses DA key ROLE1(as OP2)
Then assign date time value for entry entry0
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

Scenario: Caller verifies the call history list
Then HMI OP2 verifies that call history list contains 3 entries
When HMI OP2 selects call history list entry number: 0
Then HMI OP2 verifies that call history call button has label ROLE1(as OP2)
When HMI OP2 selects call history list entry number: 1
Then HMI OP2 verifies that call history call button has label OP3
When HMI OP2 selects call history list entry number: 2
Then HMI OP2 verifies that call history call button has label OP1

Scenario: Caller verifies call history additional informations
Then HMI OP2 verifies call history entry number 0 matches entry0
Then HMI OP2 verifies call history entry number 1 matches entry1
Then HMI OP2 verifies call history entry number 2 matches entry2

Scenario: Caller closes call history
Then HMI OP2 closes Call History popup window

Scenario: Change mission for HMI OP1
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Caller opens call history
When HMI OP2 presses function key CALLHISTORY

Scenario: Caller verifies the call history list
		  @REQUIREMENTS:GID-4084003
Then HMI OP2 verifies that call history list contains 3 entries
When HMI OP2 selects call history list entry number: 0
Then HMI OP2 verifies that call history call button has label ROLE1(as OP2)
When HMI OP2 selects call history list entry number: 1
Then HMI OP2 verifies that call history call button has label OP3
When HMI OP2 selects call history list entry number: 2
Then HMI OP2 verifies that call history call button has label OP1

Scenario: Caller verifies call history additional informations
Then HMI OP2 verifies call history entry number 0 matches entry0
Then HMI OP2 verifies call history entry number 1 matches entry1
Then HMI OP2 verifies call history entry number 2 matches entry2

Scenario: Caller closes call history
Then HMI OP2 closes Call History popup window
