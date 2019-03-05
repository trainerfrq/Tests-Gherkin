Narrative:
As an operator having configured "Idle on Position Unattended" set to enabled
I want to wait the time span for the Warning message to expire without any user interaction
So I can verify that Idle status is activated

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
Then HMI OP1 verifies warning popup countdown is visible

Scenario: Op1 changes to mission WEST-EXEC
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: "Position Unattended" as warning state in Notification Bar
Then HMI OP1 has a notification that shows Position Unattended

Scenario: Verify that Idle Warning Popup is not visible
Then HMI OP1 verifies that popup unattended is not visible

Scenario: Op1 wait for 10 sec and verifies that Idle Popup is not visible either
Then waiting for 10 seconds
Then HMI OP1 verifies that popup idle is not visible

Scenario: Op1 verifies that LSP is enabled and can't be disabled
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Op1 verifies that calls can be sent
When HMI OP1 presses DA key OP1
Then HMI OP1 has the DA key OP1 in state out_ringing
When HMI OP1 presses DA key OP1

Scenario: Op1 changes to mission MAN-NIGHT-TACT
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify that Idle Popup is visible and contains expected text
Then HMI OP1 verifies that popup idle is visible
Then HMI OP1 verifies that idle popup contains the text: idle

Scenario: Op1 verifies that DA keys are disabled
Given HMI OP1 has the DA key OP2(as OP1) disabled
Given HMI OP1 has the DA key OP3(as OP1) disabled

Scenario: Check that interaction with settings and maintenance is allowed
Then HMI OP1 opens Maintenance panel from idle popup
Then HMI OP1 closes maintenance
Then HMI OP1 opens Settings panel from idle popup
Then HMI OP1 closes settings

Scenario: Reconnect headsets
Then WS1 sends changed event request - reconnect headsets

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
Then HMI OP1 has the DA key OP3(as OP1) in state out_initiated
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 verifies that LSP is disabled and can be enabled
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled





