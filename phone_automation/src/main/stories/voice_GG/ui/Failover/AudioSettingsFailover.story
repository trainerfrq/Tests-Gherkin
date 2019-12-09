Narrative:
As a caller operator
I want to verify that if one Op Voice partition is down
The audio settings remain unchanged

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Verify display status after stopping and starting op voice instances from one partition
GivenStories: voice_GG/includes/KillStartOpVoiceActiveOnDockerHost1.story
Then waiting for 70 seconds
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Op2 closes settings popup window
Then HMI OP2 closes popup settings if window is visible
Scenario: Open settings
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key SETTINGS

Scenario: Mutes audio sliders and buttons
When HMI OP2 drags volume slider userInput to muted level
Then HMI OP2 verifies that volume slider userInput is set to level 0
When HMI OP2 drags volume slider chime to muted level
Then HMI OP2 verifies that volume slider chime is set to level 0
When HMI OP2 drags volume slider coach to muted level
Then HMI OP2 verifies that volume slider coach is set to level 0
When HMI OP2 drags volume slider operator to muted level
Then HMI OP2 verifies that volume slider operator is set to level 0
When HMI OP2 clicks on mute button Chime
Then HMI OP2 verifies that mute button Chime is in muted state
When HMI OP2 clicks on mute button UserInput
Then HMI OP2 verifies that mute button UserInput is in muted state
When HMI OP2 clicks on mute button Coach
Then HMI OP2 verifies that mute button Coach is in muted state
When HMI OP2 clicks on mute button Operator
Then HMI OP2 verifies that mute button Operator is in muted state

Scenario: Verify notification that chime is muted
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that list State contains text Chime muted

Scenario: Close popup window
Then HMI OP2 closes notification popup

Scenario: Op2 opens settings tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key SETTINGS

Scenario: Op2 opens audio settings tab
When HMI OP2 clicks on volumeControlPanel button

Scenario: Mutes audio sliders and buttons
When HMI OP2 drags volume slider coachSidetone to muted level
Then HMI OP2 verifies that volume slider coachSidetone is set to level 0
When HMI OP2 drags volume slider operatorSidetone to muted level
Then HMI OP2 verifies that volume slider operatorSidetone is set to level 0
When HMI OP2 drags volume slider notificationError to muted level
Then HMI OP2 verifies that volume slider notificationError is set to level 0
When HMI OP2 clicks on side tone mute button coach
Then HMI OP2 verifies that mute sidetone button coach is in muted state
When HMI OP2 clicks on side tone mute button operator
Then HMI OP2 verifies that mute sidetone button operator is in muted state
When HMI OP2 clicks on mute button NotificationError
Then HMI OP2 verifies that mute button NotificationError is in muted state

Scenario: Op2 closes audio settings tab
Then HMI OP2 closes advancedSetting popup

Scenario: Close settings tab
Then HMI OP2 closes settings popup

Scenario: Verify display status after the stopping the op voice instances from one partition
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
When HMI OP2 verifies that loading screen is visible
Then HMI OP2 has in the DISPLAY STATUS section connection the state DEGRADED

Scenario: Op2 closes settings popup window
Then HMI OP2 closes settings popup

Scenario: Verify audio settings
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key SETTINGS
Then HMI OP2 verifies that volume slider userInput is set to level 0
Then HMI OP2 verifies that mute button UserInput is in muted state
Then HMI OP2 verifies that volume slider chime is set to level 0
Then HMI OP2 verifies that mute button Chime is in muted state
Then HMI OP2 verifies that volume slider coach is set to level 0
Then HMI OP2 verifies that mute button Coach is in muted state
Then HMI OP2 verifies that volume slider operator is set to level 0
Then HMI OP2 verifies that mute button Operator is in muted state
When HMI OP2 clicks on volumeControlPanel button
Then HMI OP2 verifies that volume slider coachSidetone is set to level 0
Then HMI OP2 verifies that volume slider operatorSidetone is set to level 0
Then HMI OP2 verifies that volume slider notificationError is set to level 0
Then HMI OP2 verifies that mute sidetone button coach is in muted state
Then HMI OP2 verifies that mute sidetone button operator is in muted state
Then HMI OP2 verifies that mute button NotificationError is in muted state

Scenario: Verify notification that chime is muted
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that list State contains text Chime muted

Scenario: Close popup window
Then HMI OP2 closes notification popup

Scenario: Open settings
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key SETTINGS

Scenario: Change the sliders to maximum
When HMI OP2 drags volume slider userInput to maximum level
Then HMI OP2 verifies that volume slider userInput is set to level 100
Then HMI OP2 verifies that mute button UserInput is in unmuted state
When HMI OP2 drags volume slider chime to maximum level
Then HMI OP2 verifies that volume slider chime is set to level 100
Then HMI OP2 verifies that mute button Chime is in unmuted state
When HMI OP2 drags volume slider coach to maximum level
Then HMI OP2 verifies that volume slider coach is set to level 100
Then HMI OP2 verifies that mute button Coach is in unmuted state
When HMI OP2 drags volume slider operator to maximum level
Then HMI OP2 verifies that volume slider operator is set to level 100
Then HMI OP2 verifies that mute button Operator is in unmuted state

Scenario: Op2 opens audio settings tab
When HMI OP2 clicks on volumeControlPanel button

Scenario: Change the sliders to maximum
When HMI OP2 drags volume slider coachSidetone to maximum level
Then HMI OP2 verifies that volume slider coachSidetone is set to level 100
Then HMI OP2 verifies that mute sidetone button coach is in unmuted state
When HMI OP2 drags volume slider operatorSidetone to maximum level
Then HMI OP2 verifies that volume slider operatorSidetone is set to level 100
Then HMI OP2 verifies that mute sidetone button operator is in unmuted state
When HMI OP2 drags volume slider notificationError to maximum level
Then HMI OP2 verifies that volume slider notificationError is set to level 100
Then HMI OP2 verifies that mute button NotificationError is in unmuted state

Scenario: Op2 closes audio settings tab
Then HMI OP2 closes advancedSetting popup

Scenario: Close settings tab
Then HMI OP2 closes settings popup

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 70 seconds
Then HMI OP2 has in the DISPLAY STATUS section connection the state CONNECTED
