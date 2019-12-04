Narrative:
As a caller operator having an call forward active
I want to verify that if one Op Voice partition is down
The call forward is still active and the functionality is not affected

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

Scenario: Verify displayed status
GivenStories: voice_GG/includes/KillStartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP3 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Op1 closes open popup window
Then HMI OP1 closes popup settings if window is visible

Scenario: Op2 closes open popup window
Then HMI OP2 closes popup settings if window is visible

Scenario: Op3 closes open popup window
Then HMI OP3 closes popup settings if window is visible

Scenario: Op1 activates Call Forward and chooses Op2 as call forward target
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state
When HMI OP1 presses DA key OP2
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: <<OP2_NAME>>

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: Call is automatically forwarded to Op2
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has the DA key OP3 in state inc_initiated

Scenario: Op2 client answers the incoming call
When HMI OP2 presses DA key OP3

Scenario: Verify call is connected for both operators
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Verify displayed status after the stopping the op voice instances from one partition
		  @REQUIREMENTS:GID-4034511
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the DISPLAY STATUS section connection the state DEGRADED
When HMI OP2 verifies that loading screen is visible
Then HMI OP2 has in the DISPLAY STATUS section connection the state DEGRADED
When HMI OP3 verifies that loading screen is visible
Then HMI OP3 has in the DISPLAY STATUS section connection the state DEGRADED

Scenario: Op1 closes open popup window
Then HMI OP1 closes popup settings if window is visible

Scenario: Op2 closes open popup window
Then HMI OP2 closes popup settings if window is visible

Scenario: Op3 closes open popup window
Then HMI OP3 closes popup settings if window is visible

Scenario: Op1 still has Call Forward active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Verify DA keys state
Given HMI OP3 has the DA key OP1 in ready to be used state

Given HMI OP2 has the DA key OP3 in ready to be used state

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: Call is automatically forwarded to Op2
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has the DA key OP3 in state inc_initiated

Scenario: Op2 client answers the incoming call
When HMI OP2 presses DA key OP3

Scenario: Verify call is connected for both operators
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP3 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Time to wait between failover tests
Then waiting for 1 minute

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
