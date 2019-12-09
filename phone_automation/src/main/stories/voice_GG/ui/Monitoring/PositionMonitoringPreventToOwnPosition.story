Narrative:
As an operator having outgoing position monitoring calls enabled
I want to activate monitoring on my own operator position
So I can verify that I can't monitor my own position

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Op1 activates Monitoring
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP1 has the DA key OP1 with visible state monitoringOngoingState

Scenario: Op1 chooses to monitor Op1
		  @REQUIREMENTS:GID-2505728
When HMI OP1 starts monitoring gg calls for OP1
And waiting for 1 second
Then HMI OP1 verifies that the DA key OP1 has the info label failed
Then wait for 5 seconds

Scenario: Verify Notification Display list shows Select Monitoring target
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Select Monitoring target
When HMI OP1 selects tab event from notification display popup
Then HMI OP1 verifies that list Event contains on position 0 text General failure for phone call to

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Stop monitoring ongoing on the function key
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then wait for 10 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting for 1 millisecond

