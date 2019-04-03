Narrative:
As an operator
I want verify a call entry in the history list
So I can find additional information about the call

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

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

Scenario: Caller establishes 1st outgoing call - not established - and verifies additional information
		  @REQUIREMENTS:GID-3225207
When HMI OP2 presses DA key OP1
Then assign date time value for entry entry5
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP1 has the DA key OP2(as OP1) in state inc_initiated
When HMI OP2 presses DA key OP1
Then call duration for entry entry5 is calculated
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 1 matches entry5
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 1 matches date format for entry5

Scenario: Op2 closes Call History window
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes 2nd outgoing call - established - and verifies additional information
When HMI OP2 presses DA key OP1
Then assign date time value for entry entry4
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP1 has the DA key OP2(as OP1) in state inc_initiated
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1)  in state connected
Then HMI OP2 has the DA key OP1 in state connected
And wait for 5 seconds
When HMI OP2 presses DA key OP1
Then call duration for entry entry4 is calculated
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 1 matches entry4
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 1 matches date format for entry4


Scenario: Op2 closes Call History window
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes 3rd outgoing call - IA call - and verifies additional information
When HMI OP2 presses IA key IA - OP1
Then assign date time value for entry entry3
Then HMI OP2 has the IA key IA - OP1 in state connected
When HMI OP2 presses IA key IA - OP1
Then call duration for entry entry3 is calculated
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 1 matches entry3
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 1 matches date format for entry3

Scenario: Op2 closes Call History window
Then HMI OP2 closes Call History popup window


Scenario: Caller establishes 4th outgoing call - incoming for OP2 - and verifies additional information
When HMI OP1 presses DA key OP2(as OP1)
Then assign date time value for entry entry2
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then call duration for entry entry2 is calculated
When HMI OP1 presses DA key OP2(as OP1)
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 1 matches entry2
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 1 matches date format for entry2

Scenario: Op2 closes Call History window
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes 5th outgoing IA call and verifies additional information
When HMI OP1 presses IA key IA - OP2(as OP1)
Then assign date time value for entry entry1
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected
And wait for 3 seconds
Then call duration for entry entry1 is calculated
When HMI OP1 presses IA key IA - OP2(as OP1)
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 1 matches entry1
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 1 matches date format for entry1

Scenario: Op2 closes Call History window
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes 6th outgoing call - priority - and verifies additional information
When HMI OP2 initiates a priority call on DA key OP1
Then assign date time value for entry entry0
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP1 has the DA key OP2(as OP1) in state inc_initiated
When HMI OP1 presses DA key OP2(as OP1)
When HMI OP1 presses DA key OP2(as OP1)
Then call duration for entry entry0 is calculated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 1 matches entry0
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 1 matches date format for entry0

Scenario: Op2 closes Call History window
Then HMI OP2 closes Call History popup window
