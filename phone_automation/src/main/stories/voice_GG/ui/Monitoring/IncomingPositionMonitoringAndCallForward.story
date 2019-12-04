Narrative:
As an operator being monitored by another operator position
I want to activate CallForward to the position monitoring me
So I can verify that call forward and monitoring are working as expected

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

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key OP1 with visible state monitoringOngoingState

Scenario: Op3 chooses to monitor Op1
When HMI OP3 starts monitoring gg calls for OP1
Then HMI OP3 has the DA key OP1 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringActive state

Scenario: Op1 has the visual indication that it is monitored
		  @REQUIREMENTS:GID-2505728
		  @REQUIREMENTS:GID-2505731
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 verifies the call queue item OP3-OP1-MONITORING has label type showing GG
Then HMI OP1 verifies the call queue item OP3-OP1-MONITORING has label name showing <<OP3_NAME>>

Scenario: Op1 activates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op1 chooses Op3 as call forward target
When HMI OP1 presses DA key OP3
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: <<OP3_NAME>>

Scenario: Op1 has the visual indication that it is still monitored
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 verifies the call queue item OP3-OP1-MONITORING has label type showing GG
Then HMI OP1 verifies the call queue item OP3-OP1-MONITORING has label name showing <<OP3_NAME>>

Scenario: Op3 terminates all monitoring calls
When HMI OP3 with layout <<LAYOUT_MISSION3>> terminates monitoring calls using function key MONITORING menu

Scenario: Op1 has no visual indication that it is still monitored
Then HMI OP1 verifies that call queue container monitoring is not visible

Scenario: Op1 verifies that Call Forward is still active
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: <<OP3_NAME>>

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op1 activates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op1 chooses Op2 as call forward target
When HMI OP1 presses DA key OP2
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: <<OP2_NAME>>

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key OP1 with visible state monitoringOngoingState

Scenario: Op3 chooses to monitor Op1
When HMI OP3 starts monitoring gg calls for OP1
Then wait for 1 seconds 
Then HMI OP3 verifies that the DA key OP1 has the info label failed

Scenario: Stop monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING

Scenario: Op3 clears failed call on Op1
When HMI OP3 presses DA key OP1

Scenario: Op1 has no visual indication that is monitored
Then HMI OP1 verifies that call queue container monitoring is not visible

Scenario: Op2 has no visual indication that is monitored
Then HMI OP2 verifies that call queue container monitoring is not visible

Scenario: Op1 verifies that Call Forward is still active
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: <<OP2_NAME>>

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: Call is automatically forwarded to Op2
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has the DA key OP3 in state inc_initiated

Scenario: Op3 terminates call
When HMI OP3 presses DA key OP1
Then wait for 2 seconds
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
