Narrative:
As a conference initiator having an active conference
I want to change mission
So I can verify that the conference is not affected by this action

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key          | source                 | target                   | callType |
| OP1-OP2      | sip:111111@example.com | sip:222222@example.com   | DA/IDA   |
| OP2-OP1      | sip:222222@example.com | sip:111111@example.com   | DA/IDA   |
| OP1-OP2-Conf | sip:111111@example.com | sip:222222@example.com   | CONF     |
| OP2-OP1-Conf | <<OPVOICE2_CONF_URI>>  | sip:111111@example.com   | DA/IDA   |
| OP2-OP3-Conf | <<OPVOICE2_CONF_URI>>  | sip:op3@example.com:5060 | DA/IDA   |
| OP2-Conf     | conf                   | conf                     | DA/IDA   |

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

Scenario: Op2 starts a conference using an existing active call
When HMI OP2 starts a conference using an existing active call
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 1 more participant
Then HMI OP2 has a notification that shows Conference call active

Scenario: Op1 call state verification
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected

Scenario: Op2 adds another participant to the conference
When HMI OP2 presses DA key OP3

Scenario: Op3 client receives the incoming call and answers the call
Then HMI OP3 has the call queue item OP2-OP3-Conf in state inc_initiated
Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: Op2 verifies conference participants list
		  @REQUIREMENTS:GID-3229804
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name sip:op3@example.com
Then HMI OP2 verifies that remove conference participant button is disabled
Then HMI OP2 verifies that terminate conference button is enabled

Scenario: Op3 call state verification
Then HMI OP3 has the call queue item OP2-OP3-Conf in state connected

Scenario: On Op2 position DA buttons of the participants are correctly signalized
Then HMI OP2 verifies that the DA key OP1 has the info label Conference
Then HMI OP2 verifies that the DA key OP3 has the info label Conference

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: Op2 changes mission
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify conference active notification on Op2 position
Then HMI OP2 has a notification that shows Conference call active

Scenario: Verify the call state for all operators
		  @REQUIREMENTS: GID-3005111
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP2 has the call queue item OP2-Conf in state connected
Then HMI OP3 has the call queue item OP2-OP3-Conf in state connected

Scenario: Op2 verifies conference state on the call queue
Then HMI OP2 has the call queue item OP2-Conf in state connected
Then HMI OP2 has the call queue item OP2-Conf in the active list with name label CONFERENCE
Then HMI OP2 has the call queue item OP2-Conf in the active list with info label 2 more participants

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name sip:op3@example.com
Then HMI OP2 verifies that remove conference participant button is disabled
Then HMI OP2 verifies that terminate conference button is enabled

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

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
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name sip:op3@example.com
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<SIP_PHONE2>>

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: Op2 changes mission
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify conference active notification on Op2 position
Then HMI OP2 has a notification that shows Conference call active

Scenario: On Op2 position DA buttons of the participants are correctly signalized
Then HMI OP2 verifies that the DA key OP1 has the info label Conference
Then HMI OP2 verifies that the DA key OP3 has the info label Conference

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name sip:op3@example.com
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<SIP_PHONE2>>

Scenario: Op1 leaves the conference
Then HMI OP1 terminates the call queue item OP2-OP1-Conf
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op3 leaves the conference
Then HMI OP3 terminates the call queue item OP2-OP3-Conf
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op2 verifies conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
!-- Then HMI OP2 verifies in the list that conference participant on position 1 has status disconnected
!-- TODO enable step when story QXVP-8656 is implemented
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
!-- Then HMI OP2 verifies in the list that conference participant on position 2 has status disconnected
!-- TODO enable step when story QXVP-8656 is implemented
Then HMI OP2 verifies in the list that conference participant on position 2 has name sip:op3@example.com
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<SIP_PHONE2>>

Scenario: Op2 closes conference participants list
!-- Then HMI OP2 closes Conference list popup window

Scenario: Op2 leaves the conference
		  @REQUIREMENTS:GID-2529028
Then HMI OP2 leaves conference
!-- Then HMI OP2 terminates the call queue item OP2-Conf
!-- TODO enable steps after bug QXVP-14245 is fixed
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed




