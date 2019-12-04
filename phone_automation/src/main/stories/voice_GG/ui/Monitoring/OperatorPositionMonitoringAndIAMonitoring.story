Narrative:
As an operator having incoming position monitoring calls enabled and incoming IA call monitoring activated
I want to be monitored to another operator position
So I can verify that monitoring of DA and IA calls are works simultaneously

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
| OP1-OP3            | <<OP1_URI>> | <<OP3_URI>> | IA         |
| OP3-OP1            | <<OP3_URI>> | <<OP1_URI>> | IA         |

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key OP1 with visible state monitoringOngoingState

Scenario: Op3 chooses to monitor Op1
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringActive state

Scenario: Op1 has the visual indication that it is monitored
		  @REQUIREMENTS:GID-2505728
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state connected
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state tx_monitored
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Op3 opens monitoring list
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: Op3 verifies monitoring list entries
Then HMI OP3 verifies that monitoring list contains 1 entries
Then HMI OP3 verifies in the monitoring list that for entry 1 the first column has value ALL
Then HMI OP3 verifies in the monitoring list that for entry 1 the second column has value <<OP1_NAME>>

Scenario: Op3 closes monitoring popup
Then HMI OP3 closes monitoring popup

Scenario: Op3 establishes an outgoing IA call
When HMI OP3 with layout <<LAYOUT_MISSION3>>  selects grid tab 2
When HMI OP3 presses IA key IA - OP1
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP3 has the IA key IA - OP1 in state connected

Scenario: Callee receives incoming IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has the IA key IA - OP3 in state connected

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>
Then HMI OP3 has the call queue item OP1-OP3 in the active list with name label <<OP1_NAME>>

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP3-OP1 with audio direction rx_monitored
Then HMI OP3 has the IA call queue item OP1-OP3 with audio direction tx_monitored

Scenario: Verify number of calls in call queue
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP1 has in the call queue a number of 2 calls

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

Scenario: Op3 verifies that Op1 is no longer monitored
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1
Then HMI OP3 has the DA key OP1 with not visible state monitoringActiveState
Then HMI OP3 has the DA key OP1 with not visible state monitoringOngoingState

Scenario: Op3 verifies that IA monitored call to Op1 is still ongoing
		  @REQUIREMENTS:GID-2841714
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has the IA call queue item OP1-OP3 with audio direction tx_monitored

Scenario: Monitoring terminated on Op1
Then HMI OP1 verifies that call queue container monitoring is not visible

Scenario: Op1 verifies that IA monitoring call from Op3 is still ongoing
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the IA call queue item OP3-OP1 with audio direction rx_monitored

Scenario: Op3 ends outgoing IA call
When HMI OP3 with layout <<LAYOUT_MISSION3>>  selects grid tab 2
When HMI OP3 presses IA key IA - OP1
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Call is also terminated for Op1
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond


