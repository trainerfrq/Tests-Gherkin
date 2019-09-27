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
| OP1-OP3-MONITORING | <<OP1_URI>> | <<OP3_URI>> | MONITORING |
| OP2-OP3-MONITORING | <<OP2_URI>> | <<OP3_URI>> | MONITORING |
| OP1-OP3            | <<OP1_URI>> | <<OP3_URI>> | DA/IDA     |
| OP3-OP1            | <<OP3_URI>> | <<OP1_URI>> | DA/IDA     |

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op1 activates Monitoring
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP1 has the DA key OP3 with visible state monitoringOngoingState

Scenario: Op1 chooses to monitor Op3
When HMI OP1 starts monitoring gg calls on DA key OP3
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringActive state

Scenario: Op3 has the visual indication that it is monitored
Then HMI OP3 verifies that call queue container monitoring is not visible
Then HMI OP3 has the call queue item OP1-OP3-MONITORING in state connected
Then HMI OP3 has the call queue item OP1-OP3-MONITORING in state tx_monitored
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op2 activates Monitoring
When HMI OP2 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP2 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP2 has the DA key OP3 with visible state monitoringOngoingState

Scenario: Op2 chooses to monitor Op3
When HMI OP2 starts monitoring ag calls on DA key OP3
Then HMI OP2 has the DA key OP3 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
Then HMI OP2 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
When HMI OP2 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP2 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringActive state

Scenario: Op3 has the visual indication that it is monitored
Then HMI OP3 verifies that call queue container monitoring is not visible
Then HMI OP3 has the call queue item OP2-OP3-MONITORING in state connected
Then HMI OP1 has the call queue item OP2-OP3-MONITORING in state tx_monitored
Then HMI OP1 has in the call queue a number of 2 calls

Scenario: Op1 opens monitoring list
When HMI OP1 with layout <<LAYOUT_MISSION1>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that popup monitoring is visible

Scenario: Op1 verifies monitoring list entries
Then HMI OP1 verifies that monitoring list contains 1 entries
Then HMI OP1 verifies in the monitoring list that for entry 1 the first column has value GG
Then HMI OP1 verifies in the monitoring list that for entry 1 the second column has value <<OP1_NAME>>

Scenario: Op2 opens monitoring list
When HMI OP2 with layout <<LAYOUT_MISSION1>> opens monitoring list using function key MONITORING menu
Then HMI OP2 verifies that popup monitoring is visible

Scenario: Op2 verifies monitoring list entries
Then HMI OP2 verifies that monitoring list contains 1 entries
Then HMI OP2 verifies in the monitoring list that for entry 1 the first column has value AG
Then HMI OP2 verifies in the monitoring list that for entry 1 the second column has value <<OP1_NAME>>

Scenario: Op1 terminates all monitoring calls
Then HMI OP1 clicks on clearAllCalls button
Then HMI OP1 verifies that monitoring list contains 0 entries

Scenario: Op1 closes monitoring popup
Then HMI OP1 closes monitoring popup
Then HMI OP1 has the DA key OP3 with not visible state monitoringActiveState
Then HMI OP1 has the DA key OP3 with not visible state monitoringOngoingState

Scenario: Op2 terminates all monitoring calls
Then HMI OP2 clicks on clearAllCalls button
Then HMI OP2 verifies that monitoring list contains 0 entries

Scenario: Op2 closes monitoring popup
Then HMI OP2 closes monitoring popup
Then HMI OP2 has the DA key OP3 with not visible state monitoringActiveState
Then HMI OP2 has the DA key OP3 with not visible state monitoringOngoingState

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds
