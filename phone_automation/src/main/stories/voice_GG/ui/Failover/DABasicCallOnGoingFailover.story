Narrative:
As a caller operator having an active DA call with a callee operator
I want to verify that if one Op Voice partition is down
The active call will be automatically terminated, but one new DA call can be made

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

Scenario: Verify displayed status after stopping and starting op voice instances from one partition
GivenStories: voice_GG/includes/KillStartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Verify displayed status after the stopping the op voice instances from one partition
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
Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the waiting list with name label <<OP1_NAME>>

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Verify call queue section
Then HMI OP2 verifies that the call queue item OP1-OP2 was removed from the waiting list
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Verify displayed status after the stopping the op voice instances from one partition
		  @REQUIREMENTS:GID-4034511
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost1.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the DISPLAY STATUS section connection the state DEGRADED
When HMI OP2 verifies that loading screen is visible
Then HMI OP2 has in the DISPLAY STATUS section connection the state DEGRADED

Scenario: Op1 closes settings popup window
Then HMI OP1 closes settings popup

Scenario: Op2 closes settings popup window
Then HMI OP2 closes settings popup
Scenario: Call is terminated for callee
!-- TODO QXVP-9245 : enable this test after story is done
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Verify DA keys state
Given HMI OP1 has the DA key OP2 in ready to be used state

Given HMI OP2 has the DA key OP1 in ready to be used state

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Time to wait between failover tests
Then waiting for 1 minute

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
