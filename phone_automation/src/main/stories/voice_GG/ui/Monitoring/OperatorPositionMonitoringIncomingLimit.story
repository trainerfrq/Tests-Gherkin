Narrative:
As an operator having incoming position monitoring calls enabled
I want to receive monitoring calls
So I can verify that incoming monitoring calls limit is respected

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key                | source      | target      | callType   |
| OP2-OP1-MONITORING | <<OP2_URI>> | <<OP1_URI>> | MONITORING |
| OP1-OP3            | <<OP1_URI>> | <<OP3_URI>> | DA/IDA     |
| OP3-OP1            | <<OP3_URI>> | <<OP1_URI>> | DA/IDA     |

Scenario: Op1 activates Monitoring
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP1 has the DA key OP2 with visible state monitoringOngoingState

Scenario: Op1 chooses to monitor Op2
		  @REQUIREMENTS:GID-2505729
		  @REQUIREMENTS:GID-2834339
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 with visible state monitoringOngoingState
Then wait for 2 seconds
Then HMI OP1 verifies that the DA key OP2 has the info label failed

Scenario: Stop monitoring ongoing on the function key
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission EAST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op2 activates Monitoring
When HMI OP2 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP2 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP2 has the DA key OP1(as Mission3) with visible state monitoringOngoingState

Scenario: Op2 chooses to monitor Op1
When HMI OP2 starts monitoring gg calls for OP1(as Mission3)
Then HMI OP2 has the DA key OP1(as Mission3) with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
Then HMI OP2 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
When HMI OP2 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP2 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringActive state

Scenario: Op1 has the visual indication that it is monitored
		  @REQUIREMENTS:GID-3371940
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has the call queue item OP2-OP1-MONITORING in state connected
Then HMI OP1 has the call queue item OP2-OP1-MONITORING in state tx_monitored
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 verifies the call queue item OP2-OP1-MONITORING has label type showing GG
Then HMI OP1 verifies the call queue item OP2-OP1-MONITORING has label name showing <<OP2_NAME>>

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key OP1 with visible state monitoringOngoingState

Scenario: Op3 chooses to monitor Op1
		  @REQUIREMENTS:GID-2505729
		  @REQUIREMENTS:GID-2834339
When HMI OP3 presses DA key OP1
And waiting for 1 second
Then HMI OP3 verifies that the DA key OP1 has the info label busy

Scenario: Op3 stops monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then wait for 15 seconds

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing
Then HMI OP3 has the call queue item OP1-OP3 in state out_ringing

Scenario: Op1 client receives the incoming call
Then HMI OP1 has the call queue item OP3-OP1 in state inc_initiated

Scenario: Op1 client answers the incoming call
When HMI OP1 presses DA key OP3

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected

Scenario: Op1 has the visual indication that it is monitored
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has the call queue item OP2-OP1-MONITORING in state connected
Then HMI OP1 has the call queue item OP2-OP1-MONITORING in state tx_monitored
Then HMI OP1 has in the call queue a number of 2 calls

Scenario: Op2 opens monitoring list
When HMI OP2 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP2 verifies that popup monitoring is visible

Scenario: Op2 verifies monitoring list entries
Then HMI OP2 verifies that monitoring list contains 1 entries
Then HMI OP2 verifies in the monitoring list that for entry 1 the first column has value GG
Then HMI OP2 verifies in the monitoring list that for entry 1 the second column has value <<OP1_NAME>>

Scenario: Op3 closes monitoring popup
Then HMI OP2 closes monitoring popup

Scenario: Op2 terminates all monitoring calls
When HMI OP2 with layout <<LAYOUT_MISSION3>> terminates monitoring calls using function key MONITORING menu

Scenario: Monitoring terminated on Op1
Then HMI OP1 verifies that call queue container monitoring is not visible
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP3
And waiting for 1 second
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op3
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done







