Narrative:
As an operator part of an active call
I want to start a conference
So I can add more participants to the call

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key          | source                 | target                 | callType |
| OP3-OP2      | sip:op3@example.com    | sip:222222@example.com | DA/IDA   |
| OP2-OP3      | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |
| OP3-OP2-Conf | sip:op3@example.com    | sip:222222@example.com | CONF     |
| OP2-OP3-Conf | <<OPVOICE2_CONF_URI>>  | sip:op3@example.com    | DA/IDA   |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Op1 activates Call Forward
When HMI OP1 presses function key CALLFORWARD
When HMI OP1 presses DA key OP3(as OP1)
Then HMI OP1 verifies that call queue info container contains Target: op3
Then HMI OP1 has the function key CALLFORWARD in forwardActive state

Scenario: Op2 establishes an outgoing call
When HMI OP2 presses DA key OP3
Then HMI OP2 has the DA key OP3 in state out_ringing

Scenario: Op3 client receives the incoming call and answers the call
Then HMI OP3 has the DA key OP2(as OP3) in state inc_initiated
When HMI OP3 presses DA key OP2(as OP3)

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Op2 starts a conference
When HMI OP2 starts a conference
Then HMI OP2 has the call queue item OP3-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP3-OP2-Conf in the active list with name label OP3
Then HMI OP2 has the call queue item OP3-OP2-Conf in the active list with info label 1 more participant
Then HMI OP2 has a notification that shows Conference call active

Scenario: Op1 call state verification
Then HMI OP3 has the call queue item OP2-OP3-Conf in state connected

Scenario: Op2 adds a conference participant from phonebook
When HMI OP2 presses function key PHONEBOOK
When HMI OP2 selects call route selector: none
When HMI OP2 selects phonebook entry number: 2
Then HMI OP2 verifies that phone book text box displays text Madoline
When HMI OP2 initiates a call from the phonebook
When SipContact answers incoming calls

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:op3@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<SIP_PHONE2>>

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: Op2 wants to add Op1 as conference participant
When HMI OP2 presses DA key OP1

Scenario: Call will be forwarded to Op3
Then HMI OP3 has the call queue item OP2-OP3-Conf in the waiting list with name label 222222

Scenario: Op3 answers the calls
Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status terminated
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:op3@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<SIP_PHONE2>>
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name sip:111111@example.com

Scenario: Op2 removes conference participants
When HMI OP2 selects conference participant: 3
Then HMI OP2 verifies that remove conference participant button is enabled
Then HMI OP2 removes conference participant
Then HMI OP2 verifies that conference participants list contains 2 participants
When HMI OP2 selects conference participant: 2
Then HMI OP2 removes conference participant

Scenario: Verify that calls are ended for all conference participants
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Verify that Op1 hasn't any calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 deactivates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Remove phone
When SipContact is removed




