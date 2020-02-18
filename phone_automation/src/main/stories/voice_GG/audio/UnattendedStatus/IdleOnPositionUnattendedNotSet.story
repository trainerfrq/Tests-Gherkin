Narrative:
As an operator using mission with a role that hasn't "Idle on Position Unattended" set to enabled
I want to wait for a period of time
So I can verify that Idle status is not activated, but "Position Unattended" is displayed

GivenStories: voice_GG/audio/UnattendedStatus/PrepareAudioSimulator.story

Scenario: Booking profiles
Given booked profiles:
| profile   | group | host           | identifier |
| javafx    | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx    | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx    | hmi   | <<CLIENT3_IP>> | HMI OP3    |
| websocket | hmi   | <<CO3_IP>>     |            |

Scenario: Define call queue items
Given the call queue items:
| key               | source        | target        | callType |
| OP1-OP2(as Role1) | <<OP1_URI>>   |               | DA/IDA   |
| OP2(as Role1)-OP1 | <<ROLE1_URI>> | <<OP1_URI>>   | DA/IDA   |

Scenario: Close Settings popup
Then HMI OP1 closes popup settings if window is visible

Scenario: Op1 sets LSP to enabled
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP on

Scenario: Op1 changes to mission MISSION_2_NAME
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op2 changes to mission MISSION_1_NAME
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP2 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op1 verifies LSP state
Then HMI OP1 with layout <<LAYOUT_MISSION2>> has the function key LOUDSPEAKER label GG LSP on

Scenario: Disconnect headsets for Op1
Then WS1 sends changed event request - disconnect headsets

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

Scenario: Op1 verifies that call can be initiated
When HMI OP1 presses DA key OP3(as Mission2)
Then HMI OP1 has the DA key OP3(as Mission2) in state out_ringing
When HMI OP3 presses DA key OP1
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 verifies that calls can be received
When HMI OP2 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
When HMI OP2 selects phonebook entry number: 2
Then HMI OP2 verifies that phone book text box displays text <<OP1_NAME>>
When HMI OP2 initiates a call from the phonebook
Then HMI OP2 has the call queue item OP1-OP2(as Role1) in state out_ringing
Then HMI OP1 has the call queue item OP2(as Role1)-OP1 in state inc_initiated
Then HMI OP2 terminates the call queue item OP1-OP2(as Role1)

Scenario: Connect headsets
Then WS1 sends changed event request - connect headsets
And waiting for 1 second
Then HMI OP1 closes settings popup

Scenario: Op1 verifies that LSP is enabled and can be disabled
Then HMI OP1 with layout <<LAYOUT_MISSION2>> has the function key LOUDSPEAKER label GG LSP on
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION2>> has the function key LOUDSPEAKER label GG LSP off

Scenario: Verify active call is still connected
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 ends call
When HMI OP1 presses DA key OP3(as Mission2)
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 changes to mission MISSION_1_NAME
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op2 changes to mission MISSION_2_NAME
When HMI OP2 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP2 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
