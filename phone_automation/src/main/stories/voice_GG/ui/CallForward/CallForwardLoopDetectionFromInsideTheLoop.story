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
| key     | source      | target      | callType |
| OP1-OP3 | <<OP1_URI>> | <<OP3_URI>> | DA/IDA   |
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | DA/IDA   |
| OP3-OP2 | <<OP3_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |

Scenario: Op1 activates Call Forward with Op2 as call forward target
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
When HMI OP1 presses DA key OP2
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op2 activates Call Forward with Op1 as call forward target
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLFORWARD
When HMI OP2 presses DA key OP1
Then HMI OP2 with layout <<LAYOUT_MISSION2>> has the function key CALLFORWARD in active state

Scenario: Op2 fails to establish an outgoing call towards Op1
		  @REQUIREMENTS:GID-4370514
		  @REQUIREMENTS:GID-2535698
When HMI OP2 presses DA key OP1
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has the call queue item OP1-OP2 in state out_failed

Scenario: Op2 succeeds to establish an outgoing call towards Op3
When HMI OP2 presses DA key OP3
Then HMI OP3 has the call queue item OP2-OP3 in the waiting list with name label <<OP2_NAME>>

Scenario: Op2 clears outgoing call
Then HMI OP2 terminates the call queue item OP3-OP2
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 fails to establish an outgoing call towards Op2
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has the call queue item OP2-OP1 in state out_failed

Scenario: Wait for failed call to terminate
Then wait for 15 seconds
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op2 deactivates Call Forward
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLFORWARD
Then HMI OP2 verifies that call queue info container is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
