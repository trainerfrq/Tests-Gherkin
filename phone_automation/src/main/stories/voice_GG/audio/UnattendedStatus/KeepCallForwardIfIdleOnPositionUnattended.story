Narrative:
As an operator using mission with a role that has "Idle on Position Unattended" set to enabled and having Call Forward active
I want to have the Idle status activated
So I can verify that the incoming calls are still forwarded

GivenStories: voice_GG/audio/UnattendedStatus/PrepareAudioSimulator.story

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
| OP3-OP2 | sip:op3@example.com    | sip:222222@example.com | DA/IDA   |
| OP1-OP3 | sip:111111@example.com | sip:op3@example.com    | DA/IDA   |
| OP1-OP2 | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1 | sip:222222@example.com | sip:111111@example.com | DA/IDA   |

Scenario: Op1 activates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 has the function key CALLFORWARD in forwardOngoing state

Scenario: Op1 chooses Op2 as call forward target
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the function key CALLFORWARD in forwardActive state
Then HMI OP1 verifies that call queue info container is visible

Scenario: Disconnect headsets for Operator 1
Then WS1 sends changed event request - disconnect headsets

Scenario: "Position Unattended" as warning state in Notification Bar
Then HMI OP1 has a notification that shows Position Unattended

Scenario: Verify that Idle Warning Popup is visible and contains expected text
		  @REQUIREMENTS:GID-2926854
Then HMI OP1 verifies that popup unattended is visible
Then HMI OP1 verifies that warning popup contains the text: Position is unattended: all handsets/headsets are unplugged!
Then HMI OP1 verifies that warning popup contains the text: Position goes into Idle state
Then HMI OP1 verifies warning popup countdown is visible

Scenario: Op1 clicks "go Idle" button from warning idle popup
Then HMI OP1 click on go Idle button from idle warning popup

Scenario: Verify that Idle Popup is visible and contains expected text
		  @REQUIREMENTS:GID-2926866
Then HMI OP1 verifies that popup idle is visible
Then HMI OP1 verifies that idle popup contains the text: Position is in Idle state: all handsets/headsets are unplugged!
Then HMI OP1 verifies that idle popup contains the text: Connect a handset or headset to continue.

Scenario: Check if call forward state is still active
		  @REQUIREMENTS:GID-2926857
Then HMI OP1 has the function key CALLFORWARD in forwardActive state
Then HMI OP1 verifies that call queue info container is visible

Scenario: Op3 establishes a call towards Op1
When HMI OP3 presses DA key OP1(as OP3)

Scenario: Verify call is forwarded towards Op2
Then HMI OP2 has the call queue item OP3-OP2 in state inc_initiated
Then HMI OP3 has the call queue item OP1-OP3 in state out_ringing

Scenario: Op3 clears the call towards Op1
When HMI OP3 presses DA key OP1(as OP3)

Scenario: Connect headsets for Operator 1
Then WS1 sends changed event request - connect headsets

Scenario: Check if call forward state is still active
		  @REQUIREMENTS:GID-2926857
Then HMI OP1 has the function key CALLFORWARD in forwardActive state
Then HMI OP1 verifies that call queue info container is visible

Scenario: Verify that Op1 can establish calls again
		  @REQUIREMENTS:GID-3281917
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op3 establishes a call towards Op1
When HMI OP3 presses DA key OP1(as OP3)

Scenario: Verify call is forwarded towards Op2
Then HMI OP2 has the call queue item OP3-OP2 in state inc_initiated
Then HMI OP3 has the call queue item OP1-OP3 in state out_ringing

Scenario: Op3 clears the call towards Op1
When HMI OP3 presses DA key OP1(as OP3)

Scenario: Op1 deactivates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible