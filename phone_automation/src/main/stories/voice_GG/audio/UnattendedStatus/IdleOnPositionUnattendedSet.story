Narrative:
As an operator using mission with a role that has "Idle on Position Unattended" set to enabled
I want to have the Idle status activated
So I can verify calls can't be done and when switch to attended position becomes fully operational again

GivenStories: voice_GG/audio/UnattendedStatus/PrepareAudioSimulator.story

Scenario: Booking profiles
Given booked profiles:
| profile   | group | host           | identifier |
| javafx    | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx    | hmi   | <<CLIENT3_IP>> | HMI OP3    |
| websocket | hmi   | <<CO3_IP>>     |            |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-1 | <<WS-Server.URI>>   | 1000             |

Scenario: Open Web Socket Client connections
Given applied the named websocket configuration:
| profile-name | websocket-config-name |
| WEBSOCKET 1  | WS_Config-1           |

Scenario: Disconnect headsets for Op1
Then WS1 sends changed event request - disconnect headsets

Scenario: "Position Unattended" as warning state in Notification Bar
Then HMI OP1 has a notification that shows Position Unattended

Scenario: Verify that Idle Warning Popup is visible and contains expected text
		  @REQUIREMENTS:GID-2926854
		  @REQUIREMENTS:GID-2926850
Then HMI OP1 verifies that popup unattended is visible
Then HMI OP1 verifies that warning popup contains the text: Position is unattended: all handsets/headsets are unplugged!
Then HMI OP1 verifies that warning popup contains the text: Position goes into Idle state in
Then HMI OP1 verifies warning popup countdown is visible

Scenario: Op1 presses button go Idle
Then HMI OP1 click on go Idle button from idle warning popup

Scenario: Verify that Idle Popup is visible and contains expected text
		  @REQUIREMENTS:GID-2926866
Then HMI OP1 verifies that popup idle is visible
Then HMI OP1 verifies that idle popup contains the text: Position is in Idle state: all handsets/headsets are unplugged!
Then HMI OP1 verifies that idle popup contains the text: Connect a handset or headset to continue.

Scenario: Check that interaction with settings and maintenance is allowed
		  @REQUIREMENTS:GID-2926857
Then HMI OP1 opens Maintenance panel from idle popup
Then HMI OP1 closes maintenance
Then HMI OP1 opens Settings panel from idle popup
Then HMI OP1 closes settings

Scenario: Connect headsets
Then WS1 sends changed event request - connect headsets

Scenario: Verify that Idle Popup is not visible
		  @REQUIREMENTS:GID-3281917
Then HMI OP1 verifies that popup idle is not visible

Scenario: Op1 verifies that DA keys are enabled
Given HMI OP1 has the DA key OP2(as OP1) in ready to be used state
Given HMI OP1 has the DA key OP3(as OP1) in ready to be used state

Scenario: Op1 verifies that calls can be sent
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 verifies that calls can be received
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP1 has the DA key OP3(as OP1) in state inc_initiated
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 verifies that LSP is disabled and can be enabled
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled
