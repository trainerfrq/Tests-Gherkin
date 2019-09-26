Narrative:
As a caller operator having to outgoing position monitoring calls enabled
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

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission EAST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key OP1 with monitoringOngoingState is visible

Scenario: Op3 chooses to monitor Op1
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 with monitoringActiveState is visible

Scenario: Op1 has the visual indication that it is monitored
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state connected
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state tx_monitored
Then HMI OP1 has in the call queue a number of 1 calls
!-- Then HMI OP1 verifies item OP3-OP1 has the monitoring type ALL
!-- Then HMI OP1 has the call queue item OP3-OP1 in the monitoring list with name label <<OP3_NAME>>

Scenario: Op2 chooses to monitor Op1
When HMI OP2 presses DA key OP1
Then HMI OP2 verifies that the DA key OP1 has the info label busy

Scenario: Verify that Op1 and Op3 still show monitoring
Then HMI OP3 has the DA key OP1 with monitoringActiveState is visible
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state tx_monitored

Scenario: Op3 terminates all monitoring calls
When HMI OP3 with layout <<LAYOUT_MISSION3>> terminates monitoring calls using function key MONITORING menu

Scenario: Monitoring not visible anymore on Op1
Then HMI OP1 verifies that call queue container monitoring is not visible
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds
