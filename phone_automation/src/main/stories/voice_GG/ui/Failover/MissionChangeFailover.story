Narrative:
As a caller operator having an assign mission
I want to verify that if one Op Voice partition is down
The assign mission remains unchanged, and if needed a new mission can be assign

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Verify displayed status
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: Change mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: Verify displayed status after stopping and starting op voice instances from one partition
GivenStories: voice_GG/includes/KillStartOpVoiceActiveOnDockerHost1.story
Then waiting for 70 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Verify displayed status after the stopping the op voice instances from one partition
		  @REQUIREMENTS:GID-4034511
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the DISPLAY STATUS section connection the state DEGRADED

Scenario: Op1 closes open popup window
Then HMI OP1 closes popup settings if window is visible

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: Change mission
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 70 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
