Narrative:
As an operator
I want to mute the volume sliders and change mission
So I can verify the sliders remain on mute state after mission change

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Op1 opens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 mutes all the volume sliders
		  @REQUIREMENTS:GID-4231218
When HMI OP1 drags volume slider userInput to muted level
Then HMI OP1 verifies that volume slider userInput is set to level 0
When HMI OP1 drags volume slider chime to muted level
Then HMI OP1 verifies that volume slider chime is set to level 0
When HMI OP1 drags volume slider coach to muted level
Then HMI OP1 verifies that volume slider coach is set to level 0
When HMI OP1 drags volume slider operator to muted level
Then HMI OP1 verifies that volume slider operator is set to level 0

Scenario: Op1 opens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 mutes all the volume sliders from audio settings
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

Scenario: Op1 changes mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_3_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op1 opens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION3>> presses function key SETTINGS

Scenario: Op1 verifies all the volume sliders are muted
Then HMI OP1 verifies that volume slider userInput is set to level 0
Then HMI OP1 verifies that volume slider chime is set to level 0
Then HMI OP1 verifies that volume slider coach is set to level 0
Then HMI OP1 verifies that volume slider operator is set to level 0

Scenario: Op1 opens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 verifies all the volume sliders from audio settings are muted
Then HMI OP1 verifies that volume slider coachSidetone is set to level 0
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 0
Then HMI OP1 verifies that volume slider notificationError is set to level 0

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes advancedSetting popup

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

Scenario: Op1 changes to initial mission
When HMI OP1 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op1 opens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 verifies all the volume sliders remain muted
Then HMI OP1 verifies that volume slider userInput is set to level 0
Then HMI OP1 verifies that volume slider chime is set to level 0
Then HMI OP1 verifies that volume slider coach is set to level 0
Then HMI OP1 verifies that volume slider operator is set to level 0

Scenario: Op1 unmutes all the volume sliders
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

Scenario: Op1 verifies all the volume sliders from settings are at maximum level
Then HMI OP1 verifies that volume slider userInput is set to level 100
Then HMI OP1 verifies that volume slider chime is set to level 100
Then HMI OP1 verifies that volume slider coach is set to level 100
Then HMI OP1 verifies that volume slider operator is set to level 100

Scenario: Op1 opens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 verifies all the volume sliders from audio settings remain muted
Then HMI OP1 verifies that volume slider coachSidetone is set to level 0
Then HMI OP1 verifies that volume slider operatorSidetone is set to level 0
Then HMI OP1 verifies that volume slider notificationError is set to level 0

Scenario: Op1 unmutes all the volume sliders from audio settings
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

Scenario: Op1 verifies all the volume sliders from audio settings are at maximum level
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
Then waiting for 1 millisecond
