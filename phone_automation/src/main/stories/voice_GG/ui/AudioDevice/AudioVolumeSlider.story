Narrative:
As an operator or coach
I want to use the volume slider
So I can adjust the sound level

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Op1 opens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 adjust all the volume sliders to mute level
		  @REQUIREMENTS:GID-4231218
When HMI OP1 drags volume slider userInput to muted level
Then HMI OP1 verifies that volume slider userInput is set to level 0
When HMI OP1 drags volume slider chime to muted level
Then HMI OP1 verifies that volume slider chime is set to level 0
When HMI OP1 drags volume slider coach to muted level
Then HMI OP1 verifies that volume slider coach is set to level 0
When HMI OP1 drags volume slider operator to muted level
Then HMI OP1 verifies that volume slider operator is set to level 0

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes settings popup

Scenario: Op1 reopens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 verifies that all the volume sliders remained at mute level
Then HMI OP1 verifies that volume slider userInput is set to level 0
Then HMI OP1 verifies that volume slider chime is set to level 0
Then HMI OP1 verifies that volume slider coach is set to level 0
Then HMI OP1 verifies that volume slider operator is set to level 0

Scenario: Op1 adjusts all the volume sliders to middle level
When HMI OP1 drags volume slider userInput to middle level
Then HMI OP1 verifies that volume slider userInput is set to level 50
When HMI OP1 drags volume slider chime to middle level
Then HMI OP1 verifies that volume slider chime is set to level 50
When HMI OP1 drags volume slider coach to middle level
Then HMI OP1 verifies that volume slider coach is set to level 50
When HMI OP1 drags volume slider operator to middle level
Then HMI OP1 verifies that volume slider operator is set to level 50

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

Scenario: Op1 reopens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 verifies that all the volume sliders remained at middle level
Then HMI OP1 verifies that volume slider userInput is set to level 50
Then HMI OP1 verifies that volume slider chime is set to level 50
Then HMI OP1 verifies that volume slider coach is set to level 50
Then HMI OP1 verifies that volume slider operator is set to level 50

Scenario: Op1 adjusts all the volume sliders to maximum level
When HMI OP1 drags volume slider userInput to maximum level
Then HMI OP1 verifies that volume slider userInput is set to level 100
When HMI OP1 drags volume slider chime to maximum level
Then HMI OP1 verifies that volume slider chime is set to level 100
When HMI OP1 drags volume slider coach to maximum level
Then HMI OP1 verifies that volume slider coach is set to level 100
When HMI OP1 drags volume slider operator to maximum level
Then HMI OP1 verifies that volume slider operator is set to level 100

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

Scenario: Op1 reopens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 verifies that all the volume sliders remained at maximum level
Then HMI OP1 verifies that volume slider userInput is set to level 100
Then HMI OP1 verifies that volume slider chime is set to level 100
Then HMI OP1 verifies that volume slider coach is set to level 100
Then HMI OP1 verifies that volume slider operator is set to level 100

Scenario: Op1 opens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 adjusts all the volume sliders from audio settings to mute level
When HMI OP1 drags volume slider coachSidetone to muted level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 0
When HMI OP1 drags volume slider operatorSidetone to muted level
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 0
When HMI OP1 drags volume slider notificationError to muted level
Then HMI OP1 verifies that volume slider notificationError is set to level 0

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes advancedSetting popup

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

Scenario: Op1 reopens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 reopens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 verifies that all the volume sliders and buttons from audio settings remained at mute level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 0
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 0
Then HMI OP1 verifies that volume slider notificationError is set to level 0

Scenario: Op1 adjusts all the volume sliders from audio settings to middle level
When HMI OP1 drags volume slider coachSidetone to middle level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 50
When HMI OP1 drags volume slider operatorSidetone to middle level
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 50
When HMI OP1 drags volume slider notificationError to middle level
Then HMI OP1 verifies that volume slider notificationError is set to level 50

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes advancedSetting popup

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

Scenario: Op1 reopens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 reopens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 verifies that all the volume sliders from audio settings remained at middle level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 50
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 50
Then HMI OP1 verifies that volume slider notificationError is set to level 50


Scenario: Op1 adjusts all the volume sliders from audio settings to maximumm level
When HMI OP1 drags volume slider coachSidetone to maximum level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 100
When HMI OP1 drags volume slider operatorSidetone to maximum level
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 100
When HMI OP1 drags volume slider notificationError to maximum level
Then HMI OP1 verifies that volume slider notificationError is set to level 100

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes advancedSetting popup

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

Scenario: Op1 reopens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 reopens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 verifies that all the volume sliders from audio settings remained at maximum level
Then HMI OP1 verifies that volume slider coachSidetone is set to level 100
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 100
Then HMI OP1 verifies that volume slider notificationError is set to level 100

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes advancedSetting popup

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
