Narrative:
As a caller operator having an assign mission
I want to verify that if one Op Voice partition is down
The assign mission remains unchanged, and if needed a new mission can be assign

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Verify displayed status
Then HMI OP1 has in the display status section connection the state CONNECTED

Scenario: Verify operator mission
Then HMI OP1 has in the display status section mission the assigned mission MAN-NIGHT-TACT

Scenario: Change mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the display status section mission the assigned mission WEST-EXEC

Scenario: Verify displayed status after stopping and starting op voice instances from one partition
GivenStories: voice_GG/includes/StopStartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the display status section connection the state CONNECTED

Scenario: Verify displayed status after the stopping the op voice instances from one partition
GivenStories: voice_GG/includes/StopOpVoiceActiveOnDockerHost2.story
Then waiting for 1 seconds
Then HMI OP1 has in the display status section connection the state DISCONNECTED

Scenario: Verify displayed status after the stopping the op voice instances from one partition
Then waiting for 3 seconds
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the display status section connection the state DEGRADED

Scenario: Verify operator mission
Then HMI OP1 has in the display status section mission the assigned mission WEST-EXEC

Scenario: Change mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the display status section mission the assigned mission MAN-NIGHT-TACT

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the display status section connection the state CONNECTED
