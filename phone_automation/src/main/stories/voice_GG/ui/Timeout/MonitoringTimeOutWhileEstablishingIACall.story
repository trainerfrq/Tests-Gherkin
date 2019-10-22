Narrative:
As an operator
I want to press Monitoring button and then establish an IA call
So I can verify that Monitoring button is in the desired state

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | IA       |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | IA       |

Scenario: Op1 presses Monitoring button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state

Scenario: Op1 verifies Monitoring button state
		  @REQUIREMENTS:GID-4402140
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible
Then HMI OP1 has the DA key OP2 with visible state monitoringOngoingState

Scenario: Op1 verifies notification message
Then HMI OP1 has a notification that shows Select Monitoring target

Scenario: Op1 establishes an outgoing IA call to Op2
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2

Scenario: Op1 verifies Monitoring button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has in the call queue a number of 0 calls
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1

Scenario: Op1 verifies Monitoring button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible
Then HMI OP1 has the DA key OP2 with visible state monitoringOngoingState

Scenario: Op1 verifies notification message
Then HMI OP1 has a notification that shows Select Monitoring target

Scenario: Op1 deactivates Monitoring button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
