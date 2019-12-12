Narrative:
As a caller operator having an active IA call with a callee operator
I want to verify that if one Op Voice partition is down
The active call will be automatically terminated, but one new IA call can be made

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | IA       |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | IA       |

Scenario: Verify displayed status after stopping and starting op voice instances from one partition
GivenStories: voice_GG/includes/KillStartOpVoiceActiveOnDockerHost1.story
Then waiting for 45 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Verify displayed status after the stopping the op voice instances from one partition
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the DISPLAY STATUS section connection the state DEGRADED
When HMI OP2 verifies that loading screen is visible
Then HMI OP2 has in the DISPLAY STATUS section connection the state DEGRADED

Scenario: Op1 closes open popup window
Then HMI OP1 closes popup settings if window is visible

Scenario: Op2 closes open popup window
Then HMI OP2 closes popup settings if window is visible

Scenario: Select second tab to make IA buttons visible
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2

Scenario: Verify IA keys state
Given HMI OP1 has the IA key IA - OP2 in ready to be used state
Given HMI OP2 has the IA key IA - OP1 in ready to be used state

Scenario: Caller establishes an half duplex IA call
When HMI OP1 presses IA key IA - OP2

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 40 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Verify displayed status after the stopping the op voice instances from one partition
		  @REQUIREMENTS:GID-4034511
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost1.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the DISPLAY STATUS section connection the state DEGRADED
When HMI OP2 verifies that loading screen is visible
Then HMI OP2 has in the DISPLAY STATUS section connection the state DEGRADED

Scenario: Op1 closes open popup window
Then HMI OP1 closes popup settings if window is visible

Scenario: Op2 closes open popup window
Then HMI OP2 closes popup settings if window is visible

Scenario: Call is terminated for calee
!-- TODO QXVP-9245 : enable this test after story is done
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Verify IA keys state
Given HMI OP1 has the IA key IA - OP2 in ready to be used state

Given HMI OP2 has the IA key IA - OP1 in ready to be used state
Then HMI OP1 has the DA key IA - OP2 in state terminated
Then HMI OP2 has the DA key IA - OP1 in state terminated

Scenario: Caller establishes an half duplex IA call
When HMI OP1 presses IA key IA - OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller client clears the phone call
When HMI OP1 presses IA key IA - OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost1.story
Then waiting for 45 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
