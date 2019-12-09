Narrative:
As an operator
I want to activate Monitoring button and then receiving a DA call
So I can verify that these actions are performed while Monitoring button timeout is active

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Cleanup events list
When HMI OP1 opens Notification Display list
When HMI OP1 clears the notification events from list
Then HMI OP1 verifies that Notification Display list Event has 0 items
Then HMI OP1 closes notification popup

Scenario: Op1 presses Monitoring button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP1 has the DA key OP2 with visible state monitoringOngoingState

Scenario: Op1 verifies Monitoring button state
		  @REQUIREMENTS:GID-4402140
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible

Scenario: Op1 verifies notification message
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Select Monitoring target
Then HMI OP1 closes notification popup

Scenario: Op2 establish an outgoing call to Op1
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state out_ringing

Scenario: Op1 verifies Monitoring button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible

Scenario: Op1 receives the incoming call and answers
Then HMI OP1 has the call queue item OP2-OP1 in state inc_initiated
When HMI OP1 presses DA key OP2

Scenario: Verifying call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op1 verifies Monitoring button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible

Scenario: Op1 clears the call
When HMI OP1 presses DA key OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 verifies Monitoring button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible

Scenario: Op1 verifies DA key state
Then HMI OP1 has the DA key OP2 with visible state monitoringOngoingState

Scenario: Op1 verifies notification message
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Select Monitoring target
Then HMI OP1 closes notification popup

Scenario: Op1 deactivates Monitoring button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting for 1 millisecond
