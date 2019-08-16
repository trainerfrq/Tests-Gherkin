Narrative:
As a caller operator having a number of calls in call history
I want to verify that if one Op Voice partition is down
The number of calls in call history remains unchanged

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Verify displayed status
GivenStories: voice_GG/includes/KillStartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Verify DA keys state
Given HMI OP1 has the DA key OP2 in ready to be used state
Given HMI OP2 has the DA key OP1 in ready to be used state

Scenario: Op1 closes settings popup window
Then HMI OP1 closes settings popup

Scenario: Op2 closes settings popup window
Then HMI OP2 closes settings popup
Scenario: Caller clears call history list
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 clears Call History list
Then HMI OP1 verifies that call history list contains 0 entries
Then HMI OP1 closes Call History popup window

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Caller opens call history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 verifies that call history list contains 1 entries

Scenario: Verify displayed status after the stopping the op voice instances from one partition
		  @REQUIREMENTS:GID-4034511
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the DISPLAY STATUS section connection the state DEGRADED
When HMI OP2 verifies that loading screen is visible
Then HMI OP2 has in the DISPLAY STATUS section connection the state DEGRADED

Scenario: Verify DA keys state
Given HMI OP1 has the DA key OP2 in ready to be used state
Given HMI OP2 has the DA key OP1 in ready to be used state

Scenario: Op1 closes settings popup window
Then HMI OP1 closes settings popup

Scenario: Op2 closes settings popup window
Then HMI OP2 closes settings popup
Scenario: Caller verifies call history list
Then HMI OP1 verifies that call history list contains 1 entries

Scenario: Caller closes call history list
Then HMI OP1 closes Call History popup window

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Time to wait between failover tests
Then waiting for 1 minute

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
