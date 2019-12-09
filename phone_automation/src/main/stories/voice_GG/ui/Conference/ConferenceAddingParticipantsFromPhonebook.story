arrative:
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
| key          | source                | target                 | callType |
| OP1-OP2      | <<OP1_URI>>           | <<OP2_URI>>            | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>           | <<OP1_URI>>            | DA/IDA   |
| OP1-OP2-Conf | <<OP1_URI>>           | <<OP2_URI>>            | CONF     |
| OP2-OP1-Conf | <<OPVOICE2_CONF_URI>> | <<OP1_URI>>            | CONF     |
| OP2-OP3-Conf | <<OPVOICE2_CONF_URI>> | <<OPVOICE3_PHONE_URI>> | CONF     |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Op2 establishes an outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Op1 client receives the incoming call and answers the call
Then HMI OP1 has the DA key OP2 in state inc_initiated
When HMI OP1 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op2 starts a conference using an existing active call
		  @REQUIREMENTS:GID-4021244
When HMI OP2 starts a conference using an existing active call
Then wait for 2 seconds
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 2 participants

Scenario: Verify conference call notification
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that list State contains text Conference call active

Scenario: Close popup window
Then HMI OP2 closes notification popup

Scenario: Op1 call state verification
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with name label CONF

Scenario: Op2 adds a conference participant from phonebook
		  @REQUIREMENTS:GID-2529024
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
When HMI OP2 selects call route selector: none
When HMI OP2 selects phonebook entry number: 9
Then HMI OP2 verifies that phone book text box displays text Madoline
When HMI OP2 initiates a call from the phonebook
When SipContact answers incoming calls

Scenario: Op2 verifies conference participants list
 @REQUIREMENTS:GID-3229804
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP1_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP2_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name Madoline

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: Op2 adds another participant to the conference
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
When HMI OP2 selects call route selector: none
When HMI OP2 selects phonebook entry number: 5
Then HMI OP2 verifies that phone book text box displays text Lloyd
When HMI OP2 initiates a call from the phonebook

Scenario: Op3 client does not receives an incoming call, because conference limit is reached
Then HMI OP3 has in the waiting list a number of 0 calls

Scenario: Verify conference call notification
When HMI OP2 opens Notification Display list
When HMI OP2 selects tab event from notification display popup
Then HMI OP2 verifies that list Event contains on position 0 text Conference limit reached
When HMI OP2 selects tab state from notification display popup

Scenario: Close popup window
Then HMI OP2 closes notification popup

Scenario: Op2 verifies conference state
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 3 participants

Scenario: Op1 leaves the conference
Then HMI OP1 terminates the call queue item OP2-OP1-Conf

Scenario: Op2 verifies conference state
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 2 participants

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP2_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name Madoline

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: Op2 (conference initiator) leaves the conference
		  @REQUIREMENTS:GID-2529028
Then HMI OP2 terminates the call queue item OP1-OP2-Conf
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
