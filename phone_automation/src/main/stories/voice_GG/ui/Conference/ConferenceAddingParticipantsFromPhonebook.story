Narrative:
As an operator part of an active DA call
I want to start a conference
So I can add participants to the call from phone book

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
| OP1-OP2      | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1      | sip:222222@example.com | sip:111111@example.com | DA/IDA   |
| OP1-OP2-Conf | sip:111111@example.com | sip:222222@example.com | CONF     |
| OP2-OP1-Conf | <<OPVOICE2_CONF_URI>>  | sip:111111@example.com | DA/IDA   |
| OP2-OP3-Conf | <<OPVOICE2_CONF_URI>>  | <<OPVOICE3_PHONE_URI>> | DA/IDA   |

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
		  @REQUIREMENTS:GID-4021244
When HMI OP2 starts a conference
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label OP1
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 1 more participant
Then HMI OP2 has a notification that shows Conference call active

Scenario: Op1 call state verification
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected

Scenario: Op2 adds a conference participant from phonebook
		  @REQUIREMENTS:GID-2529024
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
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<SIP_PHONE2>>

Scenario: Op2 adds another participant to the conference
When HMI OP2 presses function key PHONEBOOK
When HMI OP2 selects call route selector: none
When HMI OP2 selects phonebook entry number: 1
Then HMI OP2 verifies that phone book text box displays text Lloyd
When HMI OP2 initiates a call from the phonebook

Scenario: Op3 client receives the incoming call
Then HMI OP3 has the call queue item OP2-OP3-Conf in state inc_initiated

Scenario: Op2 verifies conference state
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label OP1
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 3 more participants
Then HMI OP2 has a notification that shows Conference call active

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 3 has status ringing
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OPVOICE3_PHONE_URI>>
Then HMI OP2 verifies that remove conference participant button is disabled
Then HMI OP2 verifies that terminate conference button is enabled

Scenario: Op3 client rejects the call
Then HMI OP3 rejects the waiting call queue item
Then wait for 15 seconds
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op2 verifies conference participants list
		  @REQUIREMENTS:GID-3229804
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<SIP_PHONE2>>
Then HMI OP2 verifies in the list that conference participant on position 3 has status failed
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OPVOICE3_PHONE_URI>>

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: Op2 verifies conference state
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label OP1
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 2 more participants

Scenario: Op2 (conference initiator) leaves the conference
		  @REQUIREMENTS:GID-2529028
Then HMI OP2 terminates the call queue item OP1-OP2-Conf
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is not terminated for the other participants
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Op1 leaves the conference
Then HMI OP1 terminates the call queue item OP2-OP1-Conf
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed
