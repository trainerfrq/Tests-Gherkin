Narrative:
As an operator
I want to press CallForward button without selecting a target Operator
And I also want to press another function keys
So I can verify that Call Forward button is in the desired state

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Op1 presses Call Forward button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is visible
Then HMI OP1 verifies that the DA key OP2 has the info label Call Fwd

Scenario: Op1 verifies notification message
Then HMI OP1 has a notification that shows Select Call Forward target

Scenario: Op1 presses Call History button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is not visible

Scenario: Op1 closes Call History window
Then HMI OP1 closes Call History popup window
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is not visible

Scenario: Op1 presses Call Forward button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is visible
Then HMI OP1 verifies that the DA key OP2 has the info label Call Fwd

Scenario: Op1 verifies notification message
Then HMI OP1 has a notification that shows Select Call Forward target

Scenario: Op1 presses Settings button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is visible

Scenario: Op1 closes Settings window
Then HMI OP1 closes settings popup
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is visible

Scenario: Op1 verifies notification message
Then HMI OP1 has a notification that shows Select Call Forward target

Scenario: Op1 deactivates Call Forward functionality
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
