Narrative:
As an operator
I want to mute the audio buttons and change mission
So I can verify that state of the audio buttons remains on mute after mission change

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Op1 opens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 mutes all audio buttons
		  @REQUIREMENTS:GID-4309053
		  @REQUIREMENTS:GID-4231218
Then HMI OP1 has a notification that shows Chime muted
Then HMI OP1 verifies that mute button Chime is in muted state
When HMI OP1 clicks on mute button UserInput
Then HMI OP1 verifies that mute button UserInput is in muted state
When HMI OP1 clicks on mute button Coach
Then HMI OP1 verifies that mute button Coach is in muted state
When HMI OP1 clicks on mute button Operator
Then HMI OP1 verifies that mute button Operator is in muted state

Scenario: Verify notification that chime is muted
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Chime muted

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Op1 opens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
Scenario: Op1 opens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 mutes all audio buttons from audio settings
When HMI OP1 clicks on side tone mute button coach
Then HMI OP1 verifies that mute sidetone button coach is in muted state
When HMI OP1 clicks on side tone mute button operator
Then HMI OP1 verifies that mute sidetone button operator is in muted state

When HMI OP1 clicks on mute button NotificationError
Then HMI OP1 verifies that mute button NotificationError is in muted state


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

Scenario: Op1 verifies all buttons are in muted state
Then HMI OP1 verifies that mute button Chime is in muted state
Then HMI OP1 verifies that mute button UserInput is in muted state
Then HMI OP1 verifies that mute button Coach is in muted state
Then HMI OP1 verifies that mute button Operator is in muted state

Scenario: Verify notification that chime is muted
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Chime muted

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Op1 opens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
Scenario: Op1 opens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 verifies all buttons from audio settings are in muted state
Then HMI OP1 verifies that mute sidetone button coach is in muted state
Then HMI OP1 verifies that mute sidetone button operator is in muted state
Then HMI OP1 verifies that mute button NotificationError is in muted state

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

Scenario: Op1 verifies all buttons remain in muted state
Then HMI OP1 verifies that mute button Chime is in muted state
Then HMI OP1 verifies that mute button UserInput is in muted state
Then HMI OP1 verifies that mute button Coach is in muted state
Then HMI OP1 verifies that mute button Operator is in muted state

Scenario: Verify notification that chime is muted
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Chime muted

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Op1 opens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
Scenario: Op1 unmutes all audio buttons
When HMI OP1 clicks on mute button Chime
Then HMI OP1 verifies that mute button Chime is in unmuted state
When HMI OP1 clicks on mute button UserInput
Then HMI OP1 verifies that mute button UserInput is in unmuted state
When HMI OP1 clicks on mute button Coach
Then HMI OP1 verifies that mute button Coach is in unmuted state
When HMI OP1 clicks on mute button Operator
Then HMI OP1 verifies that mute button Operator is in unmuted state

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

Scenario: Op1 reopens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 verifies all buttons remain in unmuted state
Then HMI OP1 verifies that mute button Chime is in unmuted state
Then HMI OP1 verifies that mute button UserInput is in unmuted state
Then HMI OP1 verifies that mute button Coach is in unmuted state
Then HMI OP1 verifies that mute button Operator is in unmuted state

Scenario: Op1 opens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 verifies all buttons from audio settings remain in muted state
Then HMI OP1 verifies that mute sidetone button coach is in muted state
Then HMI OP1 verifies that mute sidetone button operator is in muted state
Then HMI OP1 verifies that mute button NotificationError is in muted state

Scenario: Op1 unmutes all audio buttons from audio settings
When HMI OP1 clicks on side tone mute button coach
Then HMI OP1 verifies that mute sidetone button coach is in unmuted state
When HMI OP1 clicks on side tone mute button operator
Then HMI OP1 verifies that mute sidetone button operator is in unmuted state
When HMI OP1 clicks on mute button NotificationError
Then HMI OP1 verifies that mute button NotificationError is in unmuted state

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes advancedSetting popup

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

Scenario: Op1 reopens settings tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS

Scenario: Op1 reopens audio settings tab
When HMI OP1 clicks on volumeControlPanel button

Scenario: Op1 verifies all buttons from audio settings remain in unmuted state
Then HMI OP1 verifies that mute sidetone button coach is in unmuted state
Then HMI OP1 verifies that mute sidetone button operator is in unmuted state
Then HMI OP1 verifies that mute button NotificationError is in unmuted state

Scenario: Op1 closes audio settings tab
Then HMI OP1 closes advancedSetting popup

Scenario: Op1 closes settings tab
Then HMI OP1 closes settings popup

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
