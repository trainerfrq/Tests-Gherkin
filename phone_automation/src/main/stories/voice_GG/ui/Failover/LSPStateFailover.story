Narrative:
As a caller operator
I want to verify that if one Op Voice partition is down
The LSP state remains unchanged

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Op1 verifies loudspeaker initial state
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Verify displayed status
GivenStories: voice_GG/includes/StopStartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the display status section connection the state CONNECTED

Scenario: Caller activates loudspeaker
		  @REQUIREMENTS:GID-3005515
		  @REQUIREMENTS:GID-4231216
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Verify displayed status after the stopping the op voice instances from one partition
		  @REQUIREMENTS:GID-4034511
GivenStories: voice_GG/includes/StopOpVoiceActiveOnDockerHost2.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the display status section connection the state DEGRADED

Scenario: Op1 verifies that Loudspeaker state is unchanged
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the display status section connection the state CONNECTED

Scenario: Op1 deactivates loudspeaker
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

