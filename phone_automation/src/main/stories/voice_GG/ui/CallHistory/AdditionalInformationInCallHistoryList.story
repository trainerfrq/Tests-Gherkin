Narrative:
As an operator
I want to establish an outgoing call
So I can check that the additional information for the call is displayed in call history list

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

Scenario: Caller establishes first outgoing call - not established - and verifies additional information
            @REQUIREMENTS:GID-3225207
When HMI OP2 presses DA key OP1
Then assign date time value for entry entry5
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP1 has the DA key OP2(as OP1) in state ringing
When HMI OP2 presses DA key OP1
Then call duration for entry entry5 is calculated
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 0 matches entry5
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes second outgoing call - established - and verifies additional information
When HMI OP2 presses DA key OP1
Then assign date time value for entry entry4
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP1 has the DA key OP2(as OP1) in state ringing
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1)  in state connected
Then HMI OP2 has the DA key OP1 in state connected
And wait for 5 seconds
When HMI OP2 presses DA key OP1
Then call duration for entry entry4 is calculated
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 0 matches entry4
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes third outgoing call - IA call - and verifies additional information
When HMI OP2 presses IA key IA - OP1
Then assign date time value for entry entry3
Then HMI OP2 has the IA key IA - OP1 in state connected
When HMI OP2 presses IA key IA - OP1
Then call duration for entry entry3 is calculated
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 0 matches entry3
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes 4th outgoing call - incoming for OP2 - and verifies additional information
When HMI OP1 presses DA key OP2(as OP1)
Then assign date time value for entry entry2
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing
Then HMI OP2 has the DA key OP1 in state ringing
Then call duration for entry entry2 is calculated
When HMI OP1 presses DA key OP2(as OP1)
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 0 matches entry2
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes 5th outgoing IA call and verifies additional information
When HMI OP1 presses IA key IA - OP2(as OP1)
Then assign date time value for entry entry1
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected
And wait for 3 seconds
Then call duration for entry entry1 is calculated
When HMI OP1 presses IA key IA - OP2(as OP1)
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 0 matches entry1
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes 6th outgoing call - priority - and verifies additional information
When HMI OP2 initiates a priority call on DA key OP1
Then assign date time value for entry entry0
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP1 has the DA key OP2(as OP1) in state ringing
When HMI OP1 presses DA key OP2(as OP1)
When HMI OP1 presses DA key OP2(as OP1)
Then call duration for entry entry0 is calculated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 verifies call history entry number 0 matches entry0
Then HMI OP2 closes Call History popup window
