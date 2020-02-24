Narrative:
As an operator using mission with a role that has "Idle on Position Unattended" set to enabled
I want to change to a mission with a role that hasn't "Idle on Position Unattended" set to enabled
So I can verify that Idle status is not activated

GivenStories: voice_GG/audio/UnattendedStatus/PrepareAudioSimulator.story

Scenario: Booking profiles
Given booked profiles:
| profile   | group | host           | identifier |
| javafx    | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx    | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx    | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Disconnect headsets for Op1
Then WS1 sends changed event request - disconnect headsets

Scenario: "Position Unattended" as warning state in Notification Bar
Then HMI OP1 has a notification that shows Position Unattended

Scenario: Verify that Idle Warning Popup is visible and contains expected text
		  @REQUIREMENTS:GID-2926854
Then HMI OP1 verifies that popup unattended is visible
Then HMI OP1 verifies that warning popup contains the text: No handset or headset connected!
Then HMI OP1 verifies that warning popup contains the text: Position will go idle automatically in
Then HMI OP1 verifies warning popup countdown is visible

Scenario: Op1 prevents Idle state
		  @REQUIREMENTS:GID-2926855
Then HMI OP1 click on Stay operational button from idle warning popup

Scenario: Op1 changes to mission MISSION_2_NAME
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: "Position Unattended" as warning state in Notification Bar
Then HMI OP1 has a notification that shows Position Unattended

Scenario: Verify that Idle Warning Popup is not visible
		  @REQUIREMENTS:GID-2926850
Then HMI OP1 verifies that popup unattended is not visible

Scenario: Op1 wait for 10 sec and verifies that Idle Popup is not visible either
Then waiting for 10 seconds
Then HMI OP1 verifies that popup idle is not visible

Scenario: Op1 verifies that LSP is enabled and can't be disabled
		  @REQUIREMENTS:GID-2926852
Then HMI OP1 with layout <<LAYOUT_MISSION2>> has the function key LOUDSPEAKER label GG LSP on
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION2>> has the function key LOUDSPEAKER label GG LSP on

Scenario: Op1 verifies that calls can be sent
When HMI OP1 presses DA key OP3(as Mission2)
Then HMI OP1 has the DA key OP3(as Mission2) in state out_ringing
When HMI OP1 presses DA key OP3(as Mission2)

Scenario: Op1 changes to mission MISSION_1_NAME
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify that Idle Popup is visible and contains expected text
Then HMI OP1 verifies that popup idle is visible
Then HMI OP1 verifies that idle popup contains the text: No handset or headset connected!
Then HMI OP1 verifies that idle popup contains the text: Connect a handset or headset to continue operation.

Scenario: Check that interaction with settings and maintenance is allowed
		  @REQUIREMENTS:GID-2926857
Then HMI OP1 opens Maintenance panel from idle popup
Then HMI OP1 closes maintenance popup
Then HMI OP1 opens Settings panel from idle popup
Then HMI OP1 closes settings popup

Scenario: Connect headsets
Then WS1 sends changed event request - connect headsets
And waiting for 1 second
Then HMI OP1 closes settings popup

Scenario: Op1 verifies that DA keys are enabled
Given HMI OP1 has the DA key OP2 in ready to be used state
Given HMI OP1 has the DA key OP3 in ready to be used state

Scenario: Op1 verifies that calls can be sent
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
When HMI OP1 presses DA key OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 verifies that calls can be received
When HMI OP3 presses DA key OP1
Then HMI OP1 has the DA key OP3 in state inc_initiated
When HMI OP3 presses DA key OP1
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 verifies that LSP is disabled and can be enabled
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP on
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
