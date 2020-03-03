Narrative:
As a conference participant in an active conference
I want to receive an IA call
So I can verify that if is not a full duplex call I will not automatically leave the conference and I can also hear the IA call

Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host           | identifier |
| javafx              | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx              | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx              | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key          | source                | target      | callType |
| OP1-OP2      | <<OP1_URI>>           | <<OP2_URI>> | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>           | <<OP1_URI>> | DA/IDA   |
| OP1-OP2-Conf | <<OPVOICE1_CONF_URI>> | <<OP2_URI>> | CONF     |
| OP2-OP1-CONF | <<OP2_URI>>           | <<OP1_URI>> | CONF     |
| OP3-OP2      | <<OP3_URI>>           | <<OP2_URI>> | IA       |
| OP2-OP3      | <<OP2_URI>>           | <<OP3_URI>> | IA       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Op2 client receives the incoming call and answers the call
Then HMI OP2 has the DA key OP1 in state inc_initiated
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op1 starts a conference using an existing active call
		  @REQUIREMENTS:GID-4021244
When HMI OP1 starts a conference using an existing active call
And waiting for 1 second
Then HMI OP1 has the call queue item OP2-OP1-CONF in state connected
Then HMI OP1 has the call queue item OP2-OP1-CONF in the active list with name label CONF
Then HMI OP1 has the call queue item OP2-OP1-CONF in the active list with info label 2 participants

Scenario: Verify conference call notification
When HMI OP1 opens Notification Display list
When HMI OP1 selects tab state from notification display popup
Then HMI OP1 verifies that list State contains text Conference call active

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Op2 call state verification
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label CONF

Scenario: Op1 adds a conference participant from phonebook
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
When HMI OP1 selects call route selector: none
When HMI OP1 clicks on the scroll down button in phonebook for 1 time(s)
When HMI OP1 selects phonebook entry number: 12
Then HMI OP1 verifies that phone book text box displays text Madoline
When HMI OP1 initiates a call from the phonebook
When SipContact answers incoming calls

Scenario: Op3 establishes an outgoing IA call to Op2
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 2
When HMI OP3 presses IA key IA - OP2
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP3 has the IA key IA - OP2 in state connected

Scenario: Op2 receives incoming IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 click on call queue Elements of active list
Then HMI OP2 has in the collapsed area a number of 1 calls
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP2 has the IA key IA - OP3 in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected

Scenario: Op1 verifies conference participants list
		  @REQUIREMENTS:GID-3229804
When HMI OP1 opens the conference participants list
Then HMI OP1 verifies that conference participants list contains 3 participants
Then HMI OP1 verifies in the list that conference participant on position 1 has status connected
Then HMI OP1 verifies in the list that conference participant on position 1 has name <<OP2_NAME>>
Then HMI OP1 verifies in the list that conference participant on position 2 has status connected
Then HMI OP1 verifies in the list that conference participant on position 2 has name <<OP1_NAME>>
Then HMI OP1 verifies in the list that conference participant on position 3 has status connected
Then HMI OP1 verifies in the list that conference participant on position 3 has name Madoline

Scenario: Op1 answers the IA call
When HMI OP2 presses IA key IA - OP3

Scenario: Verify call queue for Op2 and Op3
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Verify call direction
Then HMI OP3 has the IA call queue item OP2-OP3 with audio direction duplex
Then HMI OP2 has the IA call queue item OP3-OP2 with audio direction duplex

Scenario: Op1 verifies conference participants list
		  @REQUIREMENTS:GID-2878006
Then HMI OP1 verifies that conference participants list contains 2 participants
Then HMI OP1 verifies in the list that conference participant on position 1 has status connected
Then HMI OP1 verifies in the list that conference participant on position 1 has name <<OP1_NAME>>
Then HMI OP1 verifies in the list that conference participant on position 2 has status connected
Then HMI OP1 verifies in the list that conference participant on position 2 has name Madoline

Scenario: Op2 and Op3 clear IA call
When HMI OP2 presses IA key IA - OP3
When HMI OP3 presses IA key IA - OP2
And waiting for 1 second
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Sip phone clears calls
When SipContact terminates calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: Cleanup - always select first tab
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
