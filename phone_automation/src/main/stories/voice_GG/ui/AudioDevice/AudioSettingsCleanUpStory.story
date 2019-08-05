Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Op1 opens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 unmutes the chime button
When HMI OP1 checks button Chime state and unmutes it if it finds it mute

Scenario: Op1 unmutes the user input audio button
When HMI OP1 checks button UserInput state and unmutes it if it finds it mute

Scenario: Op1 unmutes the coach button
When HMI OP1 checks button Coach state and unmutes it if it finds it mute

Scenario: Op1 unmutes the operator button
When HMI OP1 checks button Operator state and unmutes it if it finds it mute

Scenario: Op1 adjusts user input volume slider to maximum level
When HMI OP1 drags volume slider userInput to maximum level

Scenario: Op1 adjusts chime volume slider to maximum level
When HMI OP1 drags volume slider chime to maximum level

Scenario: Op1 adjusts coach volume slider to maximum level
When HMI OP1 drags volume slider coach to maximum level

Scenario: Op1 adjusts operator volume slider to maximum level
When HMI OP1 drags volume slider operator to maximum level

Scenario: Op1 opens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 unmutes coach audio button
When HMI OP1 checks side tone button coach state and unmutes it if it finds it mute

Scenario: Op1 unmutes operator audio button
When HMI OP1 checks side tone button operator state and unmutes it if it finds it mute

Scenario: Op1 unmutes notification error button
When HMI OP1 checks side tone button NotificationError state and unmutes it if it finds it mute

Scenario: Op1 adjusts coachSidetone volume slider from audio settings to maximumm level
When HMI OP1 drags volume slider coachSidetone to maximum level

Scenario: Op1 adjusts operatorSidetone volume slider from audio settings to maximumm level
When HMI OP1 drags volume slider operatorSidetone to maximum level

Scenario: Op1 adjusts notificationError volume slider from audio settings to maximumm level
When HMI OP1 drags volume slider notificationError to maximum level

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes volumeControl popup

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup
