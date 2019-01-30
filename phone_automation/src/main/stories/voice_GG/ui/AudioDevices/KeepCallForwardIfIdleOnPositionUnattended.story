Narrative:
As an operator having configured "Idle on Position Unattended" set to enabled and having Call Forward active
I want to click the "Ok" button from the warning pop-up window
So I can verify that Idle status is activated but the incoming calls are forwarded

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP3-OP2 | sip:op3@example.com    | sip:222222@example.com | DA/IDA   |
| OP2-OP3 | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |
| OP1-OP3 | sip:111111@example.com | sip:op3@example.com    | DA/IDA   |
| OP3-OP1 | sip:op3@example.com    | sip:111111@example.com | DA/IDA   |

Scenario: Op1 activates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 has the function key CALLFORWARD in forwardOngoing state
Then HMI OP1 verifies that call queue info container is not visible

Scenario: "Position Unattended" as warning state in Notification Bar

Scenario: Op1 receives warning message:"Position is unattended: all handsets/headsets are unplugged!" "Position goes into Idle state in <xx> seconds"- 662

Scenario: Op1 clicks "Ok"

Scenario: Check event log

Scenario: Check: display pop up window:
         "Position is in Idle state: all handsets/headsets are unplugged!"
         "Connect a handset or headset to continue."

Scenario: Check if call forward state

Scenario: Check event log

Scenario: ...maybe restart audio-app and choose to stay operational
