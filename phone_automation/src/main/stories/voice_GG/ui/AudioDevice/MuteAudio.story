Narrative:
As an operator
I want to mute the audio
So I can verify the sound is working properly

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Op1 opens settings tab
When HMI OP1 presses function key SETTINGS

Scenario: Op1 mutes the chime button
When HMI OP1 clicks on mute button Chime
Then HMI OP1 has a notification that shows Chime muted
Then HMI OP1 verifies that mute button Chime is in muted state

Scenario: Op1 unmutes the chime button
When HMI OP1 clicks on mute button Chime
Then HMI OP1 verifies that mute button Chime is in unmuted state

Scenario: Op1 mutes the user input audio button
When HMI OP1 clicks on mute button UserInput
Then HMI OP1 verifies that mute button UserInput is in muted state

Scenario: Op1 unmutes the user input audio button
When HMI OP1 clicks on mute button UserInput
Then HMI OP1 verifies that mute button UserInput is in unmuted state

Scenario: Op1 mutes the coach button
When HMI OP1 clicks on mute button Coach
Then HMI OP1 verifies that mute button Coach is in muted state

Scenario: Op1 unmutes the coach button
When HMI OP1 clicks on mute button Coach
Then HMI OP1 verifies that mute button Coach is in unmuted state

Scenario: Op1 mutes the operator button
When HMI OP1 clicks on mute button Operator
Then HMI OP1 verifies that mute button Operator is in muted state

Scenario: Op1 unmutes the operator button
When HMI OP1 clicks on mute button Operator
Then HMI OP1 verifies that mute button Operator is in unmuted state

Scenario: Op1 opens audio settings tab
When HMI OP1 presses function key AUDIOSETTINGS

Scenario: Op1 mutes coach audio button
When HMI OP1 clicks on side tone mute button coach
Then HMI OP1 verifies that mute sidetone button coach is in muted state

Scenario: Op1 unmutes coach audio button
When HMI OP1 clicks on side tone mute button coach
Then HMI OP1 verifies that mute sidetone button coach is in unmuted state

Scenario: Op1 mutes operator audio button
When HMI OP1 clicks on side tone mute button operator
Then HMI OP1 verifies that mute sidetone button operator is in muted state

Scenario: Op1 unmutes operator audio button
When HMI OP1 clicks on side tone mute button operator
Then HMI OP1 verifies that mute sidetone button operator is in unmuted state

Scenario: Op1 mutes notification error button
When HMI OP1 clicks on mute button NotificationError
Then HMI OP1 verifies that mute button NotificationError is in muted state

Scenario: Op1 unmutes notification error button
When HMI OP1 clicks on mute button NotificationError
Then HMI OP1 verifies that mute button NotificationError is in unmuted state

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes volumeControl popup
