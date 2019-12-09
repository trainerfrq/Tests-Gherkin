Narrative:
As an initiator of a conference
I want to receive a DA call
So I can verify that if I answer the DA call I will automatically leave the conference

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key          | source                | target      | callType |
| OP1-OP2      | <<OP1_URI>>           | <<OP2_URI>> | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>           | <<OP1_URI>> | DA/IDA   |
| OP1-OP2-Conf | <<OP1_URI>>           | <<OP2_URI>> | CONF     |
| OP2-OP1-Conf | <<OPVOICE2_CONF_URI>> | <<OP1_URI>> | CONF     |
| OP3-OP2      | <<OP3_URI>>           | <<OP2_URI>> | DA/IDA   |
| OP2-OP3      | <<OP2_URI>>           | <<OP3_URI>> | DA/IDA   |

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
When HMI OP2 starts a conference using an existing active call
And waiting for 1 second
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
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
When HMI OP2 selects call route selector: none
When HMI OP2 selects phonebook entry number: 9
Then HMI OP2 verifies that phone book text box displays text Madoline
When HMI OP2 initiates a call from the phonebook
When SipContact answers incoming calls

Scenario: Op2 verifies conference participants list
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

Scenario: Op3 establishes an outgoing call to Op2
When HMI OP3 presses DA key OP2
Then HMI OP3 has the DA key OP2 in state out_ringing

Scenario: Op2 client receives the incoming call and answers the call
		  @REQUIREMENTS:GID-2878006
Then HMI OP2 has the DA key OP3 in state inc_initiated
When HMI OP2 presses DA key OP3

Scenario: Verify call is connected for both operators
Then HMI OP2 has in the collapsed area a number of 0 calls
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Conference is not terminated also for the other participants
		  @REQUIREMENTS:GID-2529028
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with name label CONF

Scenario: Op1 verifies conference participants list
When HMI OP1 opens the conference participants list
Then HMI OP1 verifies that conference participants list contains 2 participants
Then HMI OP1 verifies in the list that conference participant on position 1 has status connected
Then HMI OP1 verifies in the list that conference participant on position 1 has name <<OP1_NAME>>
Then HMI OP1 verifies in the list that conference participant on position 2 has status connected
Then HMI OP1 verifies in the list that conference participant on position 2 has name Madoline

Scenario: Op1 closes conference participants list
Then HMI OP1 closes Conference list popup window

Scenario: Op2 client clears the phone call
When HMI OP2 presses DA key OP3
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 leaves the conference
Then HMI OP1 terminates the call queue item OP2-OP1-Conf
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting for 1 millisecond
