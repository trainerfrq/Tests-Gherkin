Narrative:
As an operator having incoming position monitoring calls enabled
I want to receive monitoring calls and change mission to a mission that has incoming and outgoing monitoring disabled
So I can verify that incoming monitoring calls is not affected by this action

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key                | source      | target      | callType   |
| OP3-OP1-MONITORING | <<OP3_URI>> | <<OP1_URI>> | MONITORING |
| OP3-OP2-MONITORING | <<OP3_URI>> | <<OP2_URI>> | MONITORING |

Scenario: Cleanup events list
When HMI OP3 opens Notification Display list
When HMI OP3 selects tab event from notification display popup
When HMI OP3 clears the notification events from list
Then HMI OP3 verifies that Notification Display list Event has 0 items
When HMI OP3 selects tab state from notification display popup

Scenario: Operator closes the Notification popup
Then HMI OP3 closes notification popup

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key OP1 with visible state monitoringOngoingState

Scenario: Op3 chooses to monitor Op1
		  @REQUIREMENTS:GID-2505728
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringActive state

Scenario: Op1 has the visual indication that it is monitored
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state connected
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state tx_monitored
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Op1 changes mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op1 has no visual indication that it is monitored
Then HMI OP1 verifies that call queue container monitoring is not visible
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op3 has no visual indication that is monitoring Op1
Then HMI OP3 has the DA key OP1 with not visible state monitoringActiveState

Scenario: Op3 opens Notification Display popup and verifies the Event list
When HMI OP3 opens Notification Display list
Then HMI OP3 verifies that popup notification is visible
When HMI OP3 selects tab event from notification display popup
Then HMI OP3 verifies that list Event contains text Monitoring call terminated by remote party <<OP_VOICE_PARTITION_KEY_1>>.

Scenario: Op3 closes the Notification popup
Then HMI OP3 closes notification popup

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING

Scenario: Op3 chooses to monitor Op1 again
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 with visible state monitoringOngoingState
Then wait for 2 seconds
Then HMI OP3 verifies that the DA key OP1 has the info label monitoring_remote_terminated

Scenario: Op3 chooses to monitor Op2
When HMI OP3 presses DA key OP2
Then HMI OP3 has the DA key OP2 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringActive state

Scenario: Op2 has the visual indication that it is monitored
Then HMI OP2 verifies that call queue container monitoring is visible
Then HMI OP2 has the call queue item OP3-OP2-MONITORING in state connected
Then HMI OP2 has the call queue item OP3-OP2-MONITORING in state tx_monitored
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Op3 opens monitoring list
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: Op3 verifies monitoring list entries
Then HMI OP3 verifies that monitoring list contains 1 entries
Then HMI OP3 verifies in the monitoring list that for entry 1 the first column has value ALL
Then HMI OP3 verifies in the monitoring list that for entry 1 the second column has value <<OP2_NAME>>

Scenario: Op3 closes monitoring popup
Then HMI OP3 closes monitoring popup

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op1 changes mission
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op2 has no visual indication that it is monitored
Then HMI OP2 verifies that call queue container monitoring is not visible
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op3 has no visual indication that is monitoring Op2
Then HMI OP3 has the DA key OP2 with not visible state monitoringActiveState

Scenario: Op3 opens Notification Display popup and verifies the Event list
When HMI OP3 opens Notification Display list
Then HMI OP3 verifies that popup notification is visible
When HMI OP3 selects tab event from notification display popup
Then HMI OP3 verifies that list Event contains text Monitoring call terminated by remote party <<OP_VOICE_PARTITION_KEY_2>>.

Scenario: Op3 closes the Notification popup
Then HMI OP3 closes notification popup

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING

Scenario: Op3 chooses to monitor Op1
When HMI OP3 presses DA key OP1

Scenario: Stop monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringActive state

Scenario: Op1 has the visual indication that it is monitored
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state connected
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state tx_monitored
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Op3 has a visual indication that is monitoring Op1
Then HMI OP3 has the DA key OP1 with visible state monitoringActiveState

Scenario: Op3 opens monitoring list
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: Op3 verifies monitoring list entries
Then HMI OP3 verifies that monitoring list contains 1 entries
Then HMI OP3 verifies in the monitoring list that for entry 1 the first column has value ALL
Then HMI OP3 verifies in the monitoring list that for entry 1 the second column has value <<OP1_NAME>>

Scenario: Op3 terminates monitoring for the selected item
When HMI OP3 selects entry 1 in the monitoring list
Then HMI OP3 clicks on clearSelected button

Scenario: Op3 closes monitoring popup
Then HMI OP3 closes monitoring popup

Scenario: Op3 has monitoring call terminated
Then HMI OP3 has the DA key OP1 with not visible state monitoringActiveState

Scenario: Monitoring terminated on Op1
Then HMI OP1 verifies that call queue container monitoring is not visible
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
