Meta:
@TEST_CASE_VERSION: V1
@TEST_CASE_NAME: Call Intrusion - Intrusion with Conference
@TEST_CASE_DESCRIPTION: 
As an operator having an active Conference call and Call Intrusion set to "Enabled"
I want to receive an incoming Priority call
So I can verify that incoming Priority Call is not conferenced to the existing Conference call
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: 
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-15583
@TEST_CASE_GLOBAL_ID: GID-5597609
@TEST_CASE_API_ID: 19963947

Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host           | identifier |
| javafx              | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx              | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx              | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key          | source                | target           | callType |
| OP1-OP2      | <<OP1_URI>>           | <<OP2_URI>>      | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>           | <<OP1_URI>>      | DA/IDA   |
| OP2-OP3      | <<OP2_URI>>           | <<OP3_URI>>      | DA/IDA   |
| OP3-OP2      | <<OP3_URI>>           | <<OP2_URI>>      | DA/IDA   |
| OP3-OP2-Conf | <<OPVOICE3_CONF_URI>> | <<OP2_URI>>      | CONF     |
| OP2-OP3-CONF | <<OPVOICE2_CONF_URI>> | <<OP3_URI>>      | CONF     |
| OP3-OP1-Conf | <<OPVOICE3_CONF_URI>> | <<OP1_URI>>:5060 | CONF     |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: OP1 changes its mission to GND
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: OP2 establishes an outgoing call
When HMI OP2 presses DA key OP3
Then HMI OP2 has the DA key OP3 in state out_ringing

Scenario: OP3 client receives the incoming call and answers the call
Then HMI OP3 has the DA key OP2 in state inc_initiated
When HMI OP3 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: OP3 starts a conference using an existing active call
When HMI OP3 starts a conference using an existing active call
And waiting for 1 second
Then HMI OP3 has the call queue item OP2-OP3-CONF in state connected
Then HMI OP3 has the call queue item OP2-OP3-CONF in the active list with name label CONF
Then HMI OP3 has the call queue item OP2-OP3-CONF in the active list with info label 2 participants

Scenario: Verify conference call notification
When HMI OP3 opens Notification Display list
When HMI OP3 selects tab state from notification display popup
Then HMI OP3 verifies that list State contains text Conference call active

Scenario: Close popup window
Then HMI OP3 closes notification popup

Scenario: OP2 call state verification
Then HMI OP2 verify (via POST request) that call queue has status ESTABLISHED
Then HMI OP2 verify (via POST request) that call queue shows CONF
!-- Then HMI OP2 has the call queue item OP3-OP2-Conf in state connected
!-- Then HMI OP2 has the call queue item OP3-OP2-Conf in the active list with name label CONF

Scenario: OP3 adds a conference participant from phonebook
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key PHONEBOOK
When HMI OP3 selects call route selector: none
When HMI OP3 clicks on the scroll down button in phonebook for 1 time(s)
When HMI OP3 selects phonebook entry number: 12
Then HMI OP3 verifies that phone book text box displays text Madoline
When HMI OP3 initiates a call from the phonebook
When SipContact answers incoming calls

Scenario: OP3 verifies conference participants list
When HMI OP3 opens the conference participants list using call queue item OP2-OP3-CONF
Then HMI OP3 verifies that conference participants list contains 3 participants
Then HMI OP3 verifies in the list that conference participant on position 1 has status connected
Then HMI OP3 verifies in the list that conference participant on position 1 has name <<OP2_NAME>>
Then HMI OP3 verifies in the list that conference participant on position 2 has status connected
Then HMI OP3 verifies in the list that conference participant on position 2 has name <<OP3_NAME>>
Then HMI OP3 verifies in the list that conference participant on position 3 has status connected
Then HMI OP3 verifies in the list that conference participant on position 3 has name Madoline

Scenario: OP3 closes conference participants list
Then HMI OP3 closes Conference list popup window

Scenario: OP2 leaves the conference
When HMI OP2 terminates (via POST request) CONF call visible on call queue
!-- Then HMI OP2 terminates the call queue item OP3-OP2-Conf
And waiting for 1 second
Then HMI OP2 has the DA key OP3 in state terminated
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: OP3 adds another participant to the conference
When HMI OP3 presses DA key OP1
And waiting for 1 second

Scenario: OP1 client receives the incoming call
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 verify (via POST request) that call queue has status RINGING
!-- Then HMI OP1 has the call queue item OP3-OP1-Conf in state inc_initiated

Scenario: OP2: Establish a priority call to OP1
When HMI OP2 initiates a priority call on DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: OP1 receives the incoming priority call
Then HMI OP1 has the DA key OP2(as GND) in state inc_initiated
Then HMI OP1 has in the call queue the item OP2-OP1 with priority

Scenario: Verify call queue section
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with name label <<OP2_NAME>>
Then HMI OP3 has the call queue item OP2-OP3-CONF in the active list with name label CONF

Scenario: Verify Notification Display
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that Notification Display list State has 0 items

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Verify intrusion Timeout bar
Then HMI OP1 verifies that intrusion Timeout bar is not visible on call queue item OP2-OP1
Then HMI OP1 verifies that intrusion Timeout bar is not visible on DA Key OP2(as GND)

Scenario: OP2 terminates the priority call
Then HMI OP2 terminates the call queue item OP1-OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: OP1 answers the conference call
Then HMI OP1 has in the call queue a number of 1 calls
When HMI OP1 answers (via POST request) CONF call by clicking on the queue
!-- Then HMI OP1 accepts the call queue item OP3-OP1-Conf

Scenario: OP2: Establish a priority call to OP1
When HMI OP2 initiates a priority call on DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: OP1 receives the incoming priority call
Then HMI OP1 has the DA key OP2(as GND) in state inc_initiated
Then HMI OP1 has in the call queue the item OP2-OP1 with priority

Scenario: Verify call queue section
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with name label <<OP2_NAME>>
Then HMI OP3 has the call queue item OP2-OP3-CONF in the active list with name label CONF

Scenario: Verify Notification Display
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Conference call active

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Verify intrusion Timeout bar
Then HMI OP1 verifies that intrusion Timeout bar is not visible on call queue item OP2-OP1
Then HMI OP1 verifies that intrusion Timeout bar is not visible on DA Key OP2(as GND)

Scenario: OP2 terminates the priority call
Then HMI OP2 terminates the call queue item OP1-OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: OP1 leaves the conference
When HMI OP1 opens the conference participants list
Then HMI OP1 leaves conference
And waiting for 1 second
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: SipContact leaves the conference
When SipContact terminates calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
