Narrative:
As an operator
I want to use the volume slider
So I can adjust the sound level

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Op1 opens settings tab
When HMI OP1 presses function key SETTINGS

Scenario: Op1 adjust the volume slider for user input
When HMI OP1 drags volume slider userInput to Y value 186
Then HMI OP1 verifies that volume slider userInput is set to level 0
When HMI OP1 drags volume slider userInput to Y value -14
Then HMI OP1 verifies that volume slider userInput is set to level 50
When HMI OP1 drags volume slider userInput to Y value -186
Then HMI OP1 verifies that volume slider userInput is set to level 100

Scenario: Op1 adjusts the volume slider for chime
When HMI OP1 drags volume slider chime to Y value 186
Then HMI OP1 verifies that volume slider chime is set to level 0
When HMI OP1 drags volume slider chime to Y value -14
Then HMI OP1 verifies that volume slider chime is set to level 50
When HMI OP1 drags volume slider chime to Y value -186
Then HMI OP1 verifies that volume slider chime is set to level 100

Scenario: Op1 adjusts the volume slider for coach
When HMI OP1 drags volume slider coach to Y value 186
Then HMI OP1 verifies that volume slider coach is set to level 0
When HMI OP1 drags volume slider coach to Y value -14
Then HMI OP1 verifies that volume slider coach is set to level 50
When HMI OP1 drags volume slider coach to Y value -186
Then HMI OP1 verifies that volume slider coach is set to level 100

Scenario: Op1 adjusts the volume slider for operator
When HMI OP1 drags volume slider operator to Y value 186
Then HMI OP1 verifies that volume slider operator is set to level 0
When HMI OP1 drags volume slider operator to Y value -14
Then HMI OP1 verifies that volume slider operator is set to level 50
When HMI OP1 drags volume slider operator to Y value -186
Then HMI OP1 verifies that volume slider operator is set to level 100

Scenario: Op1 opens audio settings tab
When HMI OP1 presses function key AUDIOSETTINGS

Scenario: Op1 adjusts the volume slider for coach side tone
When HMI OP1 drags volume slider coachSidetone to Y value 186
Then HMI OP1 verifies that volume slider coachSidetone is set to level 0
When HMI OP1 drags volume slider coachSidetone to Y value -14
Then HMI OP1 verifies that volume slider coachSidetone is set to level 50
When HMI OP1 drags volume slider coachSidetone to Y value -186
Then HMI OP1 verifies that volume slider coachSidetone is set to level 100

Scenario: Op1 adjusts the volume slider for operator side tone
When HMI OP1 drags volume slider operatorSidetone to Y value 186
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 0
When HMI OP1 drags volume slider operatorSidetone to Y value -14
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 50
When HMI OP1 drags volume slider operatorSidetone to Y value -186
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 100

Scenario: Op1 adjusts the volume slider for notification/error
When HMI OP1 drags volume slider notificationError to Y value 186
Then HMI OP1 verifies that volume slider notificationError is set to level 0
When HMI OP1 drags volume slider notificationError to Y value -14
Then HMI OP1 verifies that volume slider notificationError is set to level 50
When HMI OP1 drags volume slider notificationError to Y value -186
Then HMI OP1 verifies that volume slider notificationError is set to level 100

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes volumeControl popup