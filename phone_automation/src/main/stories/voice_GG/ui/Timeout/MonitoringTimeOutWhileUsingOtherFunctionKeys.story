Narrative:
As an operator
I want to activate Monitoring button without selecting a target Operator
Amd press another function keys
So I can verify that these actions have an influence on Monitoring button timeout

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

Scenario: Operator closes the Notification popup
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

Scenario: Operator closes the Notification popup
Then HMI OP1 closes notification popup

Scenario: Op1 presses Settings button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible

Scenario: Op1 closes Settings window
Then HMI OP1 closes settings popup
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible

Scenario: Op1 verifies notification message
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Select Monitoring target

Scenario: Operator closes the Notification popup
Then HMI OP1 closes notification popup

Scenario: Op1 presses Call History button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible

Scenario: Op1 closes Call History window
Then HMI OP1 closes Call History popup window

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

Scenario: Op1 presses Monitoring button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state

Scenario: Op1 verifies Monitoring button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is visible

Scenario: Op1 verifies DA key state
Then HMI OP1 has the DA key OP2 with visible state monitoringOngoingState

Scenario: Op1 verifies notification message
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Select Monitoring target

Scenario: Operator closes the Notification popup
Then HMI OP1 closes notification popup

Scenario: Op1 presses Call Forward button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD

Scenario: Op1 verifies Monitoring button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is not visible

Scenario: Op1 verifies notification message
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Select Call Forward target

Scenario: Operator closes the Notification popup
Then HMI OP1 closes notification popup

Scenario: Op1 verifies Call Forward button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is visible

Scenario: Op1 verifies DA key label
Then HMI OP1 verifies that the DA key OP2 has the info label Call Fwd

Scenario: Op1 deactivates Call Forward button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD

Scenario: Op1 verifies Call Forward and Monitoring buttons state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is not visible
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key MONITORING is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
