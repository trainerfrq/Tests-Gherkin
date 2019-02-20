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

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP1-OP2 | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1 | sip:222222@example.com | sip:111111@example.com | DA/IDA   |

Scenario: Op1 establishes a call towards Op2
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Op1 establishes a call towards Op3
When HMI OP1 presses DA key OP3(as OP1)
Then HMI OP1 has the DA key OP3(as OP1) in state out_ringing

Scenario: Op3 answers the incomming call
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP1 has the DA key OP3(as OP1) in state connected

Scenario: Disconnect headsets for Operator 1
Then WS1 sends changed event request - disconnect headsets

Scenario: "Position Unattended" as warning state in Notification Bar
Then HMI OP1 has a notification that shows Position Unattended

Scenario: Verify that Idle Warning Popup is visible
		  @REQUIREMENTS:GID-2926854
		  @REQUIREMENTS:GID-2926850
Then HMI OP1 verifies that warning popup is visible

Scenario: Op1 wait for 10 sec, without any interaction with Idle Warning Popup
Then waiting for 10 seconds

Scenario: Verify that the active and outgoing calls were cleared
		  @REQUIREMENTS:GID-2926857
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op3 establishes a call towards Op1
When HMI OP3 presses DA key OP1(as OP3)

Scenario: Verify that incomming call is rejected
Then HMI OP3 has the call queue item OP1-OP3 in state out_of_service
And wait for 1 seconds
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Verify Idle Popup is visible and displays the corresponding text
		  @REQUIREMENTS:GID-2926866
Then HMI OP1 verifies that idle popup is visible and contains the text: Position is in Idle state: all handsets/headsets are unplugged!
Then HMI OP1 verifies that idle popup is visible and contains the text: Connect a handset or headset to continue.

Scenario: Check that calls can't be established
Given HMI OP1 has the DA key OP2(as OP1) disabled
Given HMI OP1 has the DA key OP3(as OP1) disabled

Scenario: Check that interaction with settings and maintenance is allowed
Then HMI OP1 opens Maintenance panel from idle popup
Then HMI OP1 closes maintenance
Then HMI OP1 opens Settings panel from idle popup
Then HMI OP1 closes settings

Scenario: Reconnect headsets
Then WS1 sends changed event request - reconnect headsets

Scenario: Verify that Op1 can establish calls again
		  @REQUIREMENTS:GID-3281917
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
