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
| key     | source                   | target                 | callType |
| OP1-OP2 | <<>OPVOICE1_PHONE_URI>   |                        | DA/IDA   |
| OP2-OP1 | sip:mission1@example.com | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri     | text-buffer-size |
| WS_Config-1 | <<WS-Server.URI>> | 1000             |

Scenario: Open Web Socket Client connections
Given applied the named websocket configuration:
| profile-name | websocket-config-name |
| WEBSOCKET 1  | WS_Config-1           |

Scenario: Op1 sets LSP to enabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Op1 changes to mission WEST-EXEC
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op2 changes to mission MAN-NIGHT-TACT
When HMI OP2 presses function key MISSIONS
Then HMI OP2 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op1 verifies LSP state
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

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
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Op1 verifies that call can be initiated
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state out_ringing
When HMI OP3 presses DA key OP2(as OP3)
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 verifies that calls can be received
When HMI OP2 presses function key PHONEBOOK
When HMI OP2 selects phonebook entry number: 3
Then HMI OP2 verifies that phone book text box displays text OP1 Physical
When HMI OP2 initiates a call from the phonebook
Then HMI OP2 has the call queue item OP1-OP2 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state inc_initiated
Then HMI OP2 terminates the call queue item OP1-OP2

Scenario: Connect headsets
Then WS1 sends changed event request - connect headsets

Scenario: Op1 verifies that LSP is enabled and can be disabled
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Verify active call is still connected
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 ends call
When HMI OP1 presses DA key OP3
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 changes to mission MAN-NIGHT-TACT
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op2 changes to mission WEST-EXEC
When HMI OP2 presses function key MISSIONS
Then HMI OP2 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds
