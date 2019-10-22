Narrative:
As an operator
I want to activate Monitoring button without selecting a target Operator
So I can verify that Monitoring button is in desired state

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Op1 presses Monitoring button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state

Scenario: Op1 verifies Monitoring button state
		  @REQUIREMENTS:GID-4402140
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible
Then HMI OP1 has the DA key OP2 with visible state monitoringOngoingState

Scenario: Op1 verifies notification message
Then HMI OP1 has a notification that shows Select Monitoring target

Scenario: Op1 deactivates Monitoring button and verifies the button state
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is not visible

Scenario: Op1 presses Monitoring button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING

Scenario: Op1 waits 30 seconds and verifies Monitoring button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has timer bar for function key MONITORING in state visible for 30 seconds
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
