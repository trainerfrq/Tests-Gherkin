Narrative:
As an operator having an outgoing monitoring position call
I want to activate CallForward to the monitored position
So I can verify that call forward and monitoring are working as expected

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP3-OP2 | <<OP3_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | DA/IDA   |
| OP1-OP3 | <<OP1_URI>> | <<OP3_URI>> | DA/IDA   |
| OP3-OP1 | <<OP3_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Op1 activates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op1 chooses Op3 as call forward target
When HMI OP1 presses DA key OP3
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: <<OP3_NAME>>

Scenario: Op1 activates Monitoring
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP1 has the DA key OP3 with visible state monitoringOngoingState

Scenario: Op1 chooses to monitor Op3
		  @REQUIREMENTS:GID-2505728
When HMI OP1 starts monitoring gg calls for OP3
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringActive state

Scenario: Op1 opens monitoring list
When HMI OP1 with layout <<LAYOUT_MISSION1>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that popup monitoring is visible

Scenario: Op1 verifies monitoring list entries
Then HMI OP1 verifies that monitoring list contains 1 entries
Then HMI OP1 verifies in the monitoring list that for entry 1 the first column has value GG
Then HMI OP1 verifies in the monitoring list that for entry 1 the second column has value <<OP3_NAME>>

Scenario: Op1 closes monitoring popup
Then HMI OP1 closes monitoring popup

Scenario: Op1 terminates all monitoring calls
When HMI OP1 with layout <<LAYOUT_MISSION1>> terminates monitoring calls using function key MONITORING menu

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op1 activates Monitoring
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP1 has the DA key OP3 with visible state monitoringOngoingState

Scenario: Op1 chooses to monitor Op3
When HMI OP1 starts monitoring gg calls for OP3
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringActive state

Scenario: Op1 activates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op1 chooses Op3 as call forward target
When HMI OP1 presses DA key OP3
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: <<OP3_NAME>>

Scenario: Op1 opens monitoring list
When HMI OP1 with layout <<LAYOUT_MISSION1>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that popup monitoring is visible

Scenario: Op1 verifies monitoring list entries
Then HMI OP1 verifies that monitoring list contains 1 entries
Then HMI OP1 verifies in the monitoring list that for entry 1 the first column has value GG
Then HMI OP1 verifies in the monitoring list that for entry 1 the second column has value <<OP3_NAME>>

Scenario: Op1 closes monitoring popup
Then HMI OP1 closes monitoring popup

Scenario: Op1 terminates all monitoring calls
When HMI OP1 with layout <<LAYOUT_MISSION1>> terminates monitoring calls using function key MONITORING menu

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
