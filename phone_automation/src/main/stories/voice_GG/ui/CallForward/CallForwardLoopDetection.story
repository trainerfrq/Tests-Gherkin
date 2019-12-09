Narrative:
As a caller operator
I want to establish a call towards an operator which is in a Call Forward loop
So I can verify that the system detects the Call Forward loop and terminate calls.

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key          | source         | target      | callType |
| OP1-OP3      | <<OP1_URI>>    | <<OP3_URI>> | DA/IDA   |
| OP2-OP3      | <<OP2_URI>>    | <<OP3_URI>> | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>    | <<OP1_URI>> | DA/IDA   |
| Madoline-OP3 | <<SIP_PHONE2>> |             | DA/IDA   |

Scenario: Op1 activates Call Forward with Op2 as call forward target
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
When HMI OP1 presses DA key OP2
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op2 activates Call Forward with Op1 as call forward target
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLFORWARD
When HMI OP2 presses DA key OP1
Then HMI OP2 with layout <<LAYOUT_MISSION2>> has the function key CALLFORWARD in active state

Scenario: Op3 fails to establish an outgoing call towards Op1
		  @REQUIREMENTS:GID-4370514
When HMI OP3 presses DA key OP1
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has the call queue item OP1-OP3 in state out_failed

Scenario: Op3 fails to establish an outgoing call towards Op2
When HMI OP3 presses DA key OP2
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has the call queue item OP2-OP3 in state out_failed

Scenario: Wait for failed call to terminate
Then wait for 15 seconds
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op3 establishes an outgoing call towards someone that is not in call forward loop
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key PHONEBOOK
When HMI OP3 selects phonebook entry number: 9
Then HMI OP3 verifies that phone book text box displays text Madoline
When HMI OP3 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP3 has the call queue item Madoline-OP3 in the active list with name label Madoline

Scenario: Caller clears outgoing call
Then HMI OP3 terminates the call queue item Madoline-OP3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op2 deactivates Call Forward
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLFORWARD
Then HMI OP2 verifies that call queue info container is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting for 1 millisecond
