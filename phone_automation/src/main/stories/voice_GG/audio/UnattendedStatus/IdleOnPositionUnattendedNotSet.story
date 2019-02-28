Narrative:
As an operator having configured "Idle on Position Unattended" set to enabled
I want to wait the time span for the Warning message to expire without any user interaction
So I can verify that Idle status is activated

Scenario: Booking profiles
Given booked profiles:
| profile   | group | host           | identifier |
| javafx    | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx    | hmi   | <<CLIENT2_IP>> | HMI OP2    |
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

Scenario: Op1 changes to mission WEST-EXEC
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op2 changes to mission MAN-NIGHT-TACT
When HMI OP2 presses function key MISSIONS
Then HMI OP2 has a list of 3 missions available
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Disconnect headsets for Op1
Then WS1 sends changed event request - disconnect headsets

Scenario: "Position Unattended" as warning state in Notification Bar
Then HMI OP1 has a notification that shows Position Unattended

Scenario: Op1 verifies that LSP is enabled and can't be disabled
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Op1 verifies that calls can be sent
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing
When HMI OP2 presses DA key OP1(as OP2)
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Op1 verifies that calls can be received
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP1 has the DA key OP3(as OP1) in state out_initiated
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Reconnect headsets
Then WS1 sends changed event request - reconnect headsets

Scenario: Op1 verifies that LSP is disabled and can be disabled
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Verify active call is still connected
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Op1 ends call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 establishes a call towards Op3
When HMI OP1 presses DA key OP3(as OP1)
Then HMI OP1 has the DA key OP3(as OP1) in state out_ringing

Scenario: Op3 answers the incomming call
When HMI OP3 presses DA key OP1(as OP3)

Scenario: Verify call is connected for both operators
Then HMI OP1 has the DA key OP3(as OP1) in state connected
Then HMI OP3 has the DA key OP1(as OP3) in state connected

Scenario: Op1 ends call
When HMI OP1 presses DA key OP3(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 changes to mission MAN-NIGHT-TACT
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op2 changes to mission WEST-EXEC
When HMI OP2 presses function key MISSIONS
Then HMI OP2 has a list of 3 missions available
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds





