Narrative:
As a caller operator having to leave temporarily my Operator Position
I want to activate CallForward
So I can verify that all incoming external phone calls are forwarded to the selected target Operator Position

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key            | source                 | target                 | callType |
| SipContact-OP1 | <<SIP_PHONE2>>         | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

Scenario: Op1 activates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state

Scenario: Op1 chooses Op2 as call forward target
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: OP2 Physical
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Sip phone calls operator
When SipContact tries to establish call to SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Call is automatically forwarded to Op2
Then HMI OP2 has the call queue item SipContact-OP1 in state inc_initiated
Then HMI OP2 has the call queue item SipContact-OP1 in the waiting list with name label Madoline

Scenario: Op2 client answers the incoming call
When HMI OP2 presses the call queue item ipContact-OP1

Scenario: Verify call is connected for operator Op2
Then HMI OP2 has the call queue item SipContact-OP1 in state connected
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op3 client clears the phone call
When HMI OP2 terminates the call queue item SipContact-OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Remove phone
When SipContact is removed



