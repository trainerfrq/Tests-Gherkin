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
|OP3-OP2-MONITORING|<<OP3_URI>>|<<OP2_URI>>|MONITORING|
| OP1-OP3            | <<OP1_URI>> | <<OP3_URI>> | DA/IDA     |
| OP3-OP1            | <<OP3_URI>> | <<OP1_URI>> | DA/IDA     |

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state

Scenario: Op3 chooses to monitor Op1
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 with monitoringActiveState is visible

Scenario: Op3 chooses to monitor Op2
When HMI OP3 presses DA key OP2
Then HMI OP3 has the DA key OP2 with monitoringActiveState is visible

Scenario: Op1 has the visual indication that it is monitored
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state connected
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state tx_monitored
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Op2 has the visual indication that it is monitored
Then HMI OP2 verifies that call queue container monitoring is visible
Then HMI OP2 has the call queue item OP3-OP2-MONITORING in state connected
Then HMI OP2 has the call queue item OP3-OP2-MONITORING in state tx_monitored
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Op3 opens monitoring list
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: Op3 verifies monitoring list entries
Then HMI OP3 verifies that monitoring list contains 2 entries
Then HMI OP3 verifies in the monitoring list that for entry 1 the second column has value <<OP1_NAME>>
Then HMI OP3 verifies in the monitoring list that for entry 2 the second column has value <<OP2_NAME>>

Scenario: Op3 closes monitoring popup
Then HMI OP3 closes monitoring popup

Scenario: Verify Notification Display list shows Select Monitoring target
When HMI OP3 opens Notification Display list
Then HMI OP3 verifies that list State contains text Select Monitoring target

Scenario: Close popup window
Then HMI OP3 closes notification popup

Scenario: Op3 chooses to monitor ROLE1
When HMI OP3 presses DA key ROLE1
Then HMI OP3 has the DA key ROLE1 with monitoringOngoingState is visible

Scenario: Verify that Op1 and Op2 are still monitored
Then HMI OP3 has the DA key OP1 with monitoringActiveState is visible
Then HMI OP3 has the DA key OP2 with monitoringActiveState is visible

Scenario: Op3 opens monitoring list
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: Op3 selects entry in the monitoring list
When HMI OP3 selects entry 1 in the monitoring list
Then HMI OP3 verifies that in the monitoring window clearSelected button is enabled
Then HMI OP3 clicks on clearSelected button

Scenario: Op3 closes monitoring popup
Then HMI OP3 closes monitoring popup

Scenario: Verify that Op1 is not monitored, but Op2 is still monitored
Then HMI OP3 has the DA key OP1 with monitoringOngoingState is visible
Then HMI OP3 has the DA key OP2 with monitoringActiveState is visible

Scenario: Op3 chooses to monitor ROLE1
When HMI OP3 presses DA key ROLE1
Then HMI OP3 has the DA key ROLE1 with monitoringActiveState is visible

Scenario: Op3 opens monitoring list
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: Op3 verifies monitoring list entries
Then HMI OP3 verifies that monitoring list contains 2 entries
Then HMI OP3 verifies in the monitoring list that for entry 1 the second column has value role1
Then HMI OP3 verifies in the monitoring list that for entry 2 the second column has value <<OP2_NAME>>

Scenario: Op3 terminates all monitoring calls
Then HMI OP3 clicks on clearAllCalls button
Then HMI OP3 verifies that monitoring list contains 0 entries

Scenario: Op3 closes monitoring popup
Then HMI OP3 closes monitoring popup

Scenario: Monitoring not visible anymore on Op2
Then HMI OP2 verifies that call queue container monitoring is not visible
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds
