Narrative:
As an operator having outgoing position monitoring calls enabled
I want to activate monitoring to a role that is active on 2 positions
So I can verify that monitoring is activated only on one position without a specific priority

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key                | source      | target      | callType   |
| OP3-OP1-MONITORING | <<ROLE3_URI>> | <<ROLE1_URI>> | MONITORING |
| OP1-OP3            | <<OP1_URI>> | <<OP3_URI>> | DA/IDA     |
| OP3-OP1            | <<OP3_URI>> | <<OP1_URI>> | DA/IDA     |

Scenario: Op3 activates Monitoring to role LOWER-EAST-EXEC
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
When HMI OP3 presses DA key <<ROLE_1_NAME>>

Scenario: Stop monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING

Scenario: Op1 has the visual indication that it is monitored
		  @REQUIREMENTS:GID-2686129
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state connected
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state tx_monitored
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 verifies the call queue item OP3-OP1-MONITORING has label type showing ALL
Then HMI OP1 verifies the call queue item OP3-OP1-MONITORING has label name showing <<ROLE_3_NAME>>

Scenario: Op3 opens monitoring list
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: Op3 verifies monitoring list entries
Then HMI OP3 verifies that monitoring list contains 1 entries
Then HMI OP3 verifies in the monitoring list that for entry 1 the first column has value ALL
Then HMI OP3 verifies in the monitoring list that for entry 1 the second column has value <<ROLE_1_NAME>>

Scenario: Op3 closes monitoring popup
Then HMI OP3 closes monitoring popup

Scenario: Op3 terminates all monitoring calls
When HMI OP3 with layout <<LAYOUT_MISSION3>> terminates monitoring calls using function key MONITORING menu

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op3 activates Monitoring to role LOWER-EAST-EXEC
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
When HMI OP3 presses DA key <<ROLE_1_NAME>>

Scenario: Stop monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING

Scenario: Op3 opens monitoring list
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: Op3 verifies monitoring list entries
Then HMI OP3 verifies that monitoring list contains 1 entries
Then HMI OP3 verifies in the monitoring list that for entry 1 the first column has value ALL
Then HMI OP3 verifies in the monitoring list that for entry 1 the second column has value <<ROLE_1_NAME>>

Scenario: Op3 closes monitoring popup
Then HMI OP3 closes monitoring popup

Scenario: Op2 has the visual indication that it is monitored
Then the call queue item OP3-OP1-MONITORING is connected for only one of the operator positions: HMI OP1, HMI OP2

Scenario: Op3 terminates all monitoring calls
When HMI OP3 with layout <<LAYOUT_MISSION3>> terminates monitoring calls using function key MONITORING menu

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
