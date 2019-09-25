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
| key     | source      | target      | callType   |
| OP3-OP1 | <<OP3_URI>> | <<OP1_URI>> | MONITORING |
| OP1-OP3 | <<OP1_URI>> | <<OP3_URI>> | MONITORING |

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOngoing state
Then HMI OP3 has the DA key OP1 showing monitoringOngoingState

Scenario: Op3 chooses to monitor Op1
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 showing monitoringActiveState

Scenario: Op1 has the visual indication that it is monitored
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 verifies that the call queue item OP3-OP1 has the monitoring type ALL
Then HMI OP1 has the call queue item OP3-OP1 in the monitoring list with name label <<OP3_NAME>>
