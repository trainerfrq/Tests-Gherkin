Narrative:
As an operator having outgoing and incoming position monitoring calls enabled
I want to activate monitoring to another operator position and receive monitoring call
So I can verify that I monitoring call is visible in the Call History

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP3 | <<OP1_URI>> | <<OP3_URI>> | DA/IDA   |
| OP3-OP1 | <<OP3_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Define call history entries
Given the following call history entries:
| key    | remoteDisplayName | callDirection     | callConnectionStatus |
| entry2 | <<OP3_NAME>>      | monitoring_in_all | established          |
| entry1 | <<OP3_NAME>>      | monitoring_out_gg | established          |

Scenario: Op1 clears call history list
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 clears Call History list
Then HMI OP1 verifies that call history list contains 0 entries
Then HMI OP1 closes Call History popup window

Scenario: Op1 activates Monitoring
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP1 has the DA key OP3 with visible state monitoringOngoingState

Scenario: Op1 chooses to monitor Op3
When HMI OP1 starts monitoring gg calls for OP3
Then assign date time value for entry entry1
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING

Scenario: Op1 terminates all monitoring calls
When HMI OP1 with layout <<LAYOUT_MISSION1>> terminates monitoring calls using function key MONITORING menu

Scenario: Calculate call duration
Then call duration for entry entry1 is calculated

Scenario: Op3 activates Monitoring
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key OP1 with visible state monitoringOngoingState

Scenario: Op3 chooses to monitor Op1
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 with visible state monitoringActiveState
Then assign date time value for entry entry2

Scenario: Op1 has the visual indication that it is monitored
Then HMI OP1 verifies that call queue container monitoring is visible

Scenario: Stop monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING

Scenario: Op3 terminates all monitoring calls
When HMI OP3 with layout <<LAYOUT_MISSION3>> terminates monitoring calls using function key MONITORING menu

Scenario: Calculate call duration
Then call duration for entry entry2 is calculated

Scenario: Op1 opens call history
		  @REQUIREMENTS:GID-3225207
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 verifies that call history list contains 2 entries
Then HMI OP1 verifies call history entry number 1 matches entry2
Then HMI OP1 verifies call history entry number 2 matches entry1

Scenario: Op1 selects second entry from history
When HMI OP1 selects call history list entry number: 1
Then HMI OP1 verifies that call history call button has label <<OP3_NAME>>

Scenario: OP1 does call from call history
		  @REQUIREMENTS:GID-2535764
		  @REQUIREMENTS:GID-2536682
When HMI OP1 initiates a call from the call history
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringActive state

Scenario: Op1 terminates all monitoring calls
When HMI OP1 with layout <<LAYOUT_MISSION1>> terminates monitoring calls using function key MONITORING menu

Scenario: Op1 opens call history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 selects call history list entry number: 1
Then HMI OP1 verifies that call history call button has label <<OP3_NAME>>

Scenario: OP1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has the DA key OP3 in state out_ringing

Scenario: Op3 receives the incoming call
Then HMI OP3 has the DA key OP1 in state inc_initiated

Scenario: Op3 answers the incoming call
When HMI OP3 presses DA key OP1
Then wait for 2 seconds

Scenario: Verify call is connected for both operators
		  @REQUIREMENTS:GID-2535771
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected

Scenario: Op3 clears the phone call
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond

