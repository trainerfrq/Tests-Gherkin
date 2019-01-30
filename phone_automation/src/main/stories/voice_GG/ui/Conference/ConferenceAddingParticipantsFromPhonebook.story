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
| key                 | source                 | target                   | callType |
| OP2-OP1-Conf        | <<OPVOICE2_CONF_URI>>  | sip:111111@example.com   | DA/IDA   |
| OP2-OP3-Conf        | <<OPVOICE2_CONF_URI>>  | sip:op3@example.com:5060 | DA/IDA   |
| SipContact-OP2      | <<SIP_PHONE1>>         | <<OPVOICE2_PHONE_URI>>   | DA/IDA   |
| SipContact-OP2-Conf | <<SIP_PHONE1>>         | <<OPVOICE2_PHONE_URI>>   | CONF     |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Op2 establishes an outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Op1 client receives the incoming call and answers the call
Then HMI OP1 has the DA key OP2(as OP1) in state inc_initiated
When HMI OP1 presses DA key OP2(as OP1)

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op2 starts a conference
When HMI OP2 starts a conference
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label OP1
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 1 more participant
Then HMI OP2 has a notification that shows Conference call active

Scenario: Op1 call state verification
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected

Scenario: Op2 adds a conference participant from phonebook
When HMI OP2 presses function key PHONEBOOK
When HMI OP1 selects call route selector: none
When HMI OP1 selects phonebook entry number: 2
Then HMI OP1 verifies that phone book text box displays text Madoline
When HMI OP1 initiates a call from the phonebook
When SipContact answers incoming calls

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status ringing
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OPVOICE1_PHONE_URI>>

Scenario: Op1 client receives the incoming call and answers the call
Then HMI OP1 has the call queue item OP2-OP1-Conf in state inc_initiated
Then HMI OP1 accepts the call queue item OP2-OP1-Conf

Scenario: Op1 call state verification
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected

Scenario: Op2 verifies conference participants list
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OPVOICE1_PHONE_URI>>
Then HMI OP2 closes Conference list popup window

Scenario: Op2 adds another participant to the conference
When HMI OP2 presses function key PHONEBOOK
When HMI OP1 selects call route selector: none
When HMI OP1 selects phonebook entry number: 1
Then HMI OP1 verifies that phone book text box displays text Lloyd
When HMI OP1 initiates a call from the phonebook

Scenario: Op3 client receives the incoming call and answers the call
Then HMI OP3 has the call queue item OP2-OP3-Conf in state inc_initiated
Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: Op2 verifies conference state
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label OP1
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 3 more participants
Then HMI OP2 has a notification that shows Conference call active

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OPVOICE3_PHONE_URI>>
Then HMI OP2 verifies that remove conference participant button is disabled
Then HMI OP2 verifies that terminate conference button is enabled

Scenario: Op3 call state verification
Then HMI OP3 has the call queue item OP2-OP3-Conf in state connected

Scenario: Op2 terminates the conference from call queue
Then HMI OP2 terminates the call queue item SipContact-OP2-Conf
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for the other participants
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed
