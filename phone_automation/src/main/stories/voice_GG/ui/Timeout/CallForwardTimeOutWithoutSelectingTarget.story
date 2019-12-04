Narrative:
As an operator
I want to activate CallForward button without selecting a target Operator
So I can verify that Call Forward button timeout is in the expected state

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Cleanup events list
When HMI OP1 opens Notification Display list
When HMI OP1 clears the notification events from list
Then HMI OP1 verifies that Notification Display list Event has 0 items
Then HMI OP1 closes notification popup

Scenario: Op1 presses Call Forward button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state
Then HMI OP1 verifies that the DA key OP2 has the info label Call Fwd

Scenario: Op1 verifies Call Forward button state
		  @REQUIREMENTS:GID-4402140
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is visible

Scenario: Op1 verifies notification message
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Select Call Forward target
Then HMI OP1 closes notification popup

Scenario: Op1 deactivates Call Forward button and verifies the button state
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is not visible

Scenario: Op1 presses Call Forward button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD

Scenario: Op1 waits 30 seconds and verifies Call Forward button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has timer bar for function key CALLFORWARD in state visible for 30 seconds
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
