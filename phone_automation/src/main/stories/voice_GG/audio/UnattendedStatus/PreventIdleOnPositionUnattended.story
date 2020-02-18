Narrative:
As an operator using mission with a role that has "Idle on Position Unattended" set to enabled
I want to stay operational in unattended mode
So I can verify that Idle status is prevented and calls can be done

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
| key       | source        | target      | callType |
| ROLE1-OP3 | <<ROLE1_URI>> | <<OP3_URI>> | DA/IDA   |

Scenario: Close Settings popup
When waiting for 1 second
Then HMI OP1 closes popup settings if window is visible

Scenario: Op1 verifies LSP state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off

Scenario: Op2 establishes a call towards Op1
When HMI OP2 presses DA key OP1
Then HMI OP1 has the DA key OP2 in state inc_initiated

Scenario: Op1 establishes a call towards Op3
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state out_ringing

Scenario: Op3 answers the incomming call
When HMI OP3 presses DA key OP1
Then HMI OP1 has the DA key OP3 in state connected

Scenario: Disconnect headsets for Operator 1
Then WS1 sends changed event request - disconnect headsets
And waiting for 1 second

Scenario: Verify that Idle Warning Popup is visible and contains expected text
		  @REQUIREMENTS:GID-2926854
Then HMI OP1 verifies that popup unattended is visible
Then HMI OP1 verifies that warning popup contains the text: No handset or headset connected!
Then HMI OP1 verifies that warning popup contains the text: Position will go idle automatically in
Then HMI OP1 verifies warning popup countdown is visible

Scenario: "Position Unattended" as warning state in Notification Bar
Then HMI OP1 has a notification that shows Position Unattended

Scenario: Verify that the active and outgoing calls were not cleared
		  @REQUIREMENTS:GID-2926857
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 prevents Idle state
		  @REQUIREMENTS:GID-2926855
Then HMI OP1 click on Stay operational button from idle warning popup

Scenario: Op1 verifies that LSP is enabled and can't be disabled
		  @REQUIREMENTS:GID-2926852
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP on
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP on

Scenario: Verify that the active and outgoing calls were not cleared
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 client clears the phone calls
When HMI OP3 presses DA key OP1
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 makes a call from phone book
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
When HMI OP1 selects call route selector: none
When HMI OP1 selects phonebook entry number: 4
Then HMI OP1 verifies that phone book text box displays text <<OP3_NAME>>
When HMI OP1 initiates a call from the phonebook

Scenario: Connect headsets
Then WS1 sends changed event request - connect headsets
And waiting for 1 second

Scenario: Op1 verifies that LSP has the previous state (before unattended happened)
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP on
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off

Scenario: Op3 answers call
Then HMI OP3 accepts the call queue item ROLE1-OP3
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op3 clears call
Then HMI OP3 terminates the call queue item ROLE1-OP3
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
