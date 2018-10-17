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

Scenario: Define call history entries
Given the following call history entries:
| key     | remoteDisplayName | callDirection | callConnectionStatus|
| entry5  | OP1               | outgoing      | not_established     |
| entry4  | OP1               | outgoing      | established         |
| entry3  | IA - OP1          | outgoing      | established         |
| entry2  | 111111            | incoming      | not_established     |
| entry1  | 111111            | incoming      | established         |
| entry0  | OP1               | outgoing      | established         |

Scenario: Caller clears call history list
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 clears Call History list
Then HMI OP2 verifies that call history list contains 0 entries
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes first outgoing call - not established
When HMI OP2 presses DA key OP1
Then assign date time value for entry entry5
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP1 has the DA key OP2(as OP1) in state ringing

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP1
Then assign duration value for entry entry5

Scenario: Caller establishes second outgoing call - established
When HMI OP2 presses DA key OP1
Then assign date time value for entry entry4
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP1 has the DA key OP2(as OP1) in state ringing

Scenario: Callee client answers the incoming call
When HMI OP1 presses DA key OP2(as OP1)

Scenario: Verify call is connected for both operators
Then HMI OP1 has the DA key OP2(as OP1)  in state connected
Then HMI OP2 has the DA key OP1 in state connected
And wait for 5 seconds

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP1
Then assign duration value for entry entry4

Scenario: Caller establishes third outgoing call - IA call
When HMI OP2 presses IA key IA - OP1

Scenario: Callee receives incoming IA call
Then HMI OP2 has the IA key IA - OP1 in state connected
Then assign date time value for entry entry3

Scenario: Cleanup IA call
When HMI OP2 presses IA key IA - OP1
Then assign duration value for entry entry3

Scenario: Caller establishes 4th outgoing call - incoming for OP2
When HMI OP1 presses DA key OP2(as OP1)
Then assign date time value for entry entry2
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state ringing

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then assign duration value for entry entry2

Scenario: Caller establishes 5th outgoing IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected
Then assign date time value for entry entry1
And wait for 3 seconds

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then assign duration value for entry entry1

Scenario: Caller establishes 6th outgoing call - priority
When HMI OP2 initiates a priority call on DA key OP1
Then assign date time value for entry entry0
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Callee client receives the incoming priority call
Then HMI OP1 has the DA key OP2(as OP1) in state ringing

Scenario: Callee client answers the incoming priority call
When HMI OP1 presses DA key OP2(as OP1)

Scenario: Callee terminates call
When HMI OP1 presses DA key OP2(as OP1)
Then assign duration value for entry entry0

Scenario: Call is terminated also for both operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Caller opens call history
When HMI OP2 presses function key CALLHISTORY

Scenario: Caller verifies the call history list
Then HMI OP2 verifies that call history list contains 6 entries
Then HMI OP2 verifies call history entry number 0 matches entry0
Then HMI OP2 verifies call history entry number 1 matches entry1
Then HMI OP2 verifies call history entry number 2 matches entry2
Then HMI OP2 verifies call history entry number 3 matches entry3
Then HMI OP2 verifies call history entry number 4 matches entry4
Then HMI OP2 verifies call history entry number 5 matches entry5

Scenario: Caller closes call history
Then HMI OP2 closes Call History popup window

Scenario: Change mission for HMI OP1
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Caller opens call history
When HMI OP2 presses function key CALLHISTORY

Scenario: Caller verifies that call history list is the same after mission change
		  @REQUIREMENTS:GID-4084003
Then HMI OP2 verifies that call history list contains 6 entries
Then HMI OP2 verifies call history entry number 0 matches entry0
Then HMI OP2 verifies call history entry number 1 matches entry1
Then HMI OP2 verifies call history entry number 2 matches entry2
Then HMI OP2 verifies call history entry number 3 matches entry3
Then HMI OP2 verifies call history entry number 4 matches entry4
Then HMI OP2 verifies call history entry number 5 matches entry5

Scenario: Caller closes call history
Then HMI OP2 closes Call History popup window
