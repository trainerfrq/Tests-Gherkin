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
When HMI OP1 drags volume slider userInput to Y value 50
