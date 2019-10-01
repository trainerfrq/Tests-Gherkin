Narrative:
As an operator having outgoing position monitoring calls enabled
I want to activate monitoring to another operator position
So I can verify that I can monitor the active calls of the monitored position

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
| OP1-OP3            | <<OP1_URI>> | <<OP3_URI>> | DA/IDA     |
| OP3-OP1            | <<OP3_URI>> | <<OP1_URI>> | DA/IDA     |

Scenario: Op3 activates Monitoring
		  @REQUIREMENTS:GID-2604607
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key OP1 with visible state monitoringOngoingState

Scenario: Op3 chooses to monitor Op1
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringActive state

Scenario: Op1 has the visual indication that it is monitored
		  @REQUIREMENTS:GID-2505728
		  @REQUIREMENTS:GID-2505731
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state connected
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state tx_monitored
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 verifies the call queue item OP3-OP1-MONITORING has label type showing ALL
Then HMI OP1 verifies the call queue item OP3-OP1-MONITORING has label name showing <<OP3_NAME>>

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state out_ringing
Then HMI OP1 has the call queue item OP3-OP1 in state out_ringing

Scenario: Op3 client receives the incoming call
Then HMI OP3 has the call queue item OP1-OP3 in state inc_initiated

Scenario: Op3 client answers the incoming call
When HMI OP3 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected

Scenario: Verify number of calls in call queue
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP1 has in the call queue a number of 2 calls

Scenario: Op3 opens monitoring list
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: Op3 verifies monitoring list entries
Then HMI OP3 verifies that monitoring list contains 1 entries
Then HMI OP3 verifies in the monitoring list that for entry 1 the first column has value ALL
Then HMI OP3 verifies in the monitoring list that for entry 1 the second column has value <<OP1_NAME>>

Scenario: Op3 verifies monitoring popup buttons state
Then HMI OP3 verifies that in the monitoring window clearAllCalls button is enabled
Then HMI OP3 verifies that in the monitoring window headset button is enabled
Then HMI OP3 verifies that in the monitoring window lsp button is enabled
Then HMI OP3 verifies that in the monitoring window clearSelected button is disabled

Scenario: Op3 selects entry in the monitoring list
When HMI OP3 selects entry 1 in the monitoring list
Then HMI OP3 verifies that in the monitoring window clearSelected button is enabled

Scenario: Op3 closes monitoring popup
Then HMI OP3 closes monitoring popup

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op3
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Verify that Op1 and Op3 still show monitoring
Then HMI OP3 has the DA key OP1 with visible state monitoringActiveState
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state tx_monitored

Scenario: Op3 terminates all monitoring calls
When HMI OP3 with layout <<LAYOUT_MISSION3>> terminates monitoring calls using function key MONITORING menu

Scenario: Op3 opens monitoring list
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: Op3 verifies monitoring list entries
Then HMI OP3 verifies that monitoring list contains 0 entries

Scenario: Op3 closes monitoring popup
Then HMI OP3 closes monitoring popup
Then HMI OP3 has the DA key OP1 with not visible state monitoringActiveState
Then HMI OP3 has the DA key OP1 with not visible state monitoringOngoingState

Scenario: Monitoring not visible anymore on Op1
Then HMI OP1 verifies that call queue container monitoring is not visible
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
