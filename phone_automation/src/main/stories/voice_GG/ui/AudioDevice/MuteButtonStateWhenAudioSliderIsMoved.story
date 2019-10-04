Narrative:
As an operator
I want to mute the audio buttons, modify the audio volume sliders
So I can verify that on muting buttons the slider value remains unchanged and when moving the slider the button becomes unmuted

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Op1 opens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 checks the user input volume slider level
Then HMI OP1 verifies that volume slider userInput is set to level 100

Scenario: Op1 mutes the user input audio button
When HMI OP1 clicks on mute button UserInput
Then HMI OP1 verifies that mute button UserInput is in muted state

Scenario: Op1 verifies the user input volume slider level
Then HMI OP1 verifies that volume slider userInput is set to level 100

Scenario: Op1 unmutes the user input audio button
When HMI OP1 clicks on mute button UserInput
Then HMI OP1 verifies that mute button UserInput is in unmuted state

Scenario: Op1 verifies the user input volume slider level
Then HMI OP1 verifies that volume slider userInput is set to level 100

Scenario: Op1 mutes the user input audio button
When HMI OP1 clicks on mute button UserInput
Then HMI OP1 verifies that mute button UserInput is in muted state

Scenario: Op1 moves the user input audio slider to middle value
When HMI OP1 drags volume slider userInput to middle level
Then HMI OP1 verifies that volume slider userInput is set to level 50

Scenario: Op1 checks the user input audio button is unmuted
Then HMI OP1 verifies that mute button UserInput is in unmuted state

Scenario: Op1 moves the user input audio slider to maximum value
When HMI OP1 drags volume slider userInput to maximum level
Then HMI OP1 verifies that volume slider userInput is set to level 100

Scenario: Op1 checks the chime volume slider level
Then HMI OP1 verifies that volume slider chime is set to level 100

Scenario: Op1 mutes the chime audio button
When HMI OP1 clicks on mute button Chime
Then HMI OP1 verifies that mute button Chime is in muted state

Scenario: Op1 verifies the chime volume slider level
Then HMI OP1 verifies that volume slider chime is set to level 100

Scenario: Op1 unmutes the chime audio button
When HMI OP1 clicks on mute button Chime
Then HMI OP1 verifies that mute button Chime is in unmuted state

Scenario: Op1 verifies the chime volume slider level
Then HMI OP1 verifies that volume slider chime is set to level 100

Scenario: Op1 mutes the chime audio button
When HMI OP1 clicks on mute button Chime
Then HMI OP1 verifies that mute button Chime is in muted state

Scenario: Op1 moves the chime audio slider to middle value
When HMI OP1 drags volume slider chime to middle level
Then HMI OP1 verifies that volume slider chime is set to level 50

Scenario: Op1 checks the chime audio button is unmuted
Then HMI OP1 verifies that mute button Chime is in unmuted state

Scenario: Op1 moves the chime audio slider to maximum value
When HMI OP1 drags volume slider chime to maximum level
Then HMI OP1 verifies that volume slider chime is set to level 100

Scenario: Op1 checks the coach volume slider level
Then HMI OP1 verifies that volume slider coach is set to level 100

Scenario: Op1 mutes the coach audio button
When HMI OP1 clicks on mute button Coach
Then HMI OP1 verifies that mute button Coach is in muted state

Scenario: Op1 verifies the coach volume slider level
Then HMI OP1 verifies that volume slider coach is set to level 100

Scenario: Op1 unmutes the coach audio button
When HMI OP1 clicks on mute button Coach
Then HMI OP1 verifies that mute button Coach is in unmuted state

Scenario: Op1 verifies the coach volume slider level
Then HMI OP1 verifies that volume slider coach is set to level 100

Scenario: Op1 mutes the coach audio button
When HMI OP1 clicks on mute button Coach
Then HMI OP1 verifies that mute button Coach is in muted state

Scenario: Op1 moves the coach audio slider to middle value
When HMI OP1 drags volume slider coach to middle level
Then HMI OP1 verifies that volume slider coach is set to level 50

Scenario: Op1 checks the coach audio button is unmuted
Then HMI OP1 verifies that mute button Coach is in unmuted state

Scenario: Op1 moves the coach audio slider to maximum value
When HMI OP1 drags volume slider coach to maximum level
Then HMI OP1 verifies that volume slider coach is set to level 100

Scenario: Op1 checks the operator volume slider level
Then HMI OP1 verifies that volume slider operator is set to level 100

Scenario: Op1 mutes the operator audio button
When HMI OP1 clicks on mute button Operator
Then HMI OP1 verifies that mute button Operator is in muted state

Scenario: Op1 verifies the operator volume slider level
Then HMI OP1 verifies that volume slider operator is set to level 100

Scenario: Op1 unmutes the operator audio button
When HMI OP1 clicks on mute button Operator
Then HMI OP1 verifies that mute button Operator is in unmuted state

Scenario: Op1 verifies the operator volume slider level
Then HMI OP1 verifies that volume slider operator is set to level 100

Scenario: Op1 mutes the operator audio button
When HMI OP1 clicks on mute button Operator
Then HMI OP1 verifies that mute button Operator is in muted state

Scenario: Op1 moves the operator audio slider to middle value
When HMI OP1 drags volume slider operator to middle level
Then HMI OP1 verifies that volume slider operator is set to level 50

Scenario: Op1 checks the operator audio button is unmuted
Then HMI OP1 verifies that mute button Operator is in unmuted state

Scenario: Op1 moves the operator audio slider to maximum value
When HMI OP1 drags volume slider operator to maximum level
Then HMI OP1 verifies that volume slider operator is set to level 100

Scenario: Op1 opens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 checks the coach sidetone volume slider level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 100

Scenario: Op1 mutes coach sidetone audio button
When HMI OP1 clicks on side tone mute button coach
Then HMI OP1 verifies that mute sidetone button coach is in muted state

Scenario: Op1 checks the coach sidetone volume slider level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 100

Scenario: Op1 unmutes coach sidetone audio button
When HMI OP1 clicks on side tone mute button coach
Then HMI OP1 verifies that mute sidetone button coach is in unmuted state

Scenario: Op1 checks the coach sidetone volume slider level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 100

Scenario: Op1 mutes coach sidetone audio button
When HMI OP1 clicks on side tone mute button coach
Then HMI OP1 verifies that mute sidetone button coach is in muted state

Scenario: Op1 moves the coach sidetone audio slider to middle value
When HMI OP1 drags volume slider coachSidetone to middle level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 50

Scenario: Op1 checks the coach sidetone audio button is unmuted
Then HMI OP1 verifies that mute sidetone button coach is in unmuted state

Scenario: Op1 moves the coach sidetone audio slider to maximum value
When HMI OP1 drags volume slider coachSidetone to maximum level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 100

Scenario: Op1 checks the operator sidetone volume slider level
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 100

Scenario: Op1 mutes operator sidetone audio button
When HMI OP1 clicks on side tone mute button operator
Then HMI OP1 verifies that mute sidetone button operator is in muted state

Scenario: Op1 checks the operator sidetone volume slider level
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 100

Scenario: Op1 unmutes operator sidetone audio button
When HMI OP1 clicks on side tone mute button operator
Then HMI OP1 verifies that mute sidetone button operator is in unmuted state

Scenario: Op1 checks the operator sidetone volume slider level
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 100

Scenario: Op1 mutes operator sidetone audio button
When HMI OP1 clicks on side tone mute button operator
Then HMI OP1 verifies that mute sidetone button operator is in muted state

Scenario: Op1 moves the operator sidetone audio slider to middle value
When HMI OP1 drags volume slider operatorSidetone to middle level
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 50

Scenario: Op1 checks the operator sidetone audio button is unmuted
Then HMI OP1 verifies that mute sidetone button operator is in unmuted state

Scenario: Op1 moves the operator sidetone audio slider to maximum value
When HMI OP1 drags volume slider operatorSidetone to maximum level
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 100

Scenario: Op1 checks the notification/error volume slider level
Then HMI OP1 verifies that volume slider notificationError is set to level 100

Scenario: Op1 mutes the notification/error  audio button
When HMI OP1 clicks on mute button NotificationError
Then HMI OP1 verifies that mute button NotificationError is in muted state

Scenario: Op1 verifies the notification/error  volume slider level
Then HMI OP1 verifies that volume slider notificationError is set to level 100

Scenario: Op1 unmutes the notification/error  audio button
When HMI OP1 clicks on mute button NotificationError
Then HMI OP1 verifies that mute button NotificationError is in unmuted state

Scenario: Op1 verifies the notification/error  volume slider level
Then HMI OP1 verifies that volume slider notificationError is set to level 100

Scenario: Op1 mutes the notification/error  audio button
When HMI OP1 clicks on mute button NotificationError
Then HMI OP1 verifies that mute button NotificationError is in muted state

Scenario: Op1 moves the notification/error  audio slider to middle value
When HMI OP1 drags volume slider notificationError to middle level
Then HMI OP1 verifies that volume slider notificationError is set to level 50

Scenario: Op1 checks the notification/error  audio button is unmuted
Then HMI OP1 verifies that mute button NotificationError is in unmuted state

Scenario: Op1 moves the notification/error  audio slider to maximum value
When HMI OP1 drags volume slider notificationError to maximum level
Then HMI OP1 verifies that volume slider notificationError is set to level 100

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes advancedSetting popup

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

