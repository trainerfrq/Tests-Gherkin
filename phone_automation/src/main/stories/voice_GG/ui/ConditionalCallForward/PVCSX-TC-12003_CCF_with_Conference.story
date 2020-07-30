Meta:
@TEST_CASE_VERSION: V16
@TEST_CASE_NAME: CCF with Conference
@TEST_CASE_DESCRIPTION: As an operator having set a Conditional Call Forward rule
I want to establish a conference and to invite a third party, that matches the rule's call destination
So I can verify that the invitation is forwarded according to rule's forwarding conditions
@TEST_CASE_PRECONDITION: Settings:
A Conditional Call Forward with:
- matching call destinations: phonebook_entry
- forward calls on:                           *out of service: OP3                           *reject: no call forwarding                           *no reply: no call forwarding
- number of rule iterations: 0
Phonebook_entry <example: sip:134656@example.com> is Out of Service.
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed if the invitation to conference sent to a third party is forwarded according to a configured Conditional Call Forward rule.
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-12003
@TEST_CASE_GLOBAL_ID: GID-5171613
@TEST_CASE_API_ID: 17823383

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call source and API URI
When define values in story data:
| name    | value            |
| HMI OP1 | <<HMI1_API.URI>> |
| HMI OP2 | <<HMI2_API.URI>> |
| HMI OP3 | <<HMI3_API.URI>> |

Scenario: Define call queue items
Given the call queue items:
| key          | source                | target                      | callType |
| OP1-OP2      | <<OP1_URI>>           | <<OP2_URI>>                 | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>           | <<OP1_URI>>                 | DA/IDA   |
| OP1-OP2-CONF | <<OP1_URI>>           | <<OP2_URI>>                 | CONF     |
| OP2-OP1-Conf | <<OPVOICE2_CONF_URI>> | <<OP1_URI>>                 | CONF     |
| OP2-OP3-Conf | <<OPVOICE2_CONF_URI>> | sip:134656@example.com:5060 | CONF     |

Scenario: 1. OP1 establishes a call to OP2
Meta:
@TEST_STEP_ACTION: OP1 establishes a call to OP2
@TEST_STEP_REACTION: OP1 has a ringing call to OP2 and OP2 has a call from OP1
@TEST_STEP_REF: [CATS-REF: MZLl]
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: 1.1 OP2 receives the call
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: 1.2 Verifying call queue section
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the waiting list with name label <<OP1_NAME>>

Scenario: 2. OP2 answers the call
Meta:
@TEST_STEP_ACTION: OP2 answers the call
@TEST_STEP_REACTION: The call is connected for both OP1 and OP2
@TEST_STEP_REF: [CATS-REF: s56S]
When HMI OP2 presses DA key OP1

Scenario: 2.1 Verifying call queue section
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 3. OP2 starts a conference using the existing active call
Meta:
@TEST_STEP_ACTION: OP2 starts a conference using the existing active call 
@TEST_STEP_REACTION: OP1 and OP2 have an active call with label CONF and info label: 2 participants
@TEST_STEP_REF: [CATS-REF: inqb]
When HMI OP2 starts a conference using an existing active call
And waiting for 1 second

Scenario: 3.1 Verifying OP2 calls queue section
Then HMI OP2 has the call queue item OP1-OP2-CONF in state connected
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with info label 2 participants

Scenario: 3.2 Verifying OP1 calls queue section
Then HMI OP1 verify (via POST request) that call queue has status ESTABLISHED
Then HMI OP1 verify (via POST request) that call queue shows CONF
!-- Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
!-- Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with name label CONF
!-- Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with info label 2 participants

Scenario: 4. OP2 adds "phonebook_entry" to conference
Meta:
@TEST_STEP_ACTION: OP2 adds "phonebook_entry" to conference
@TEST_STEP_REACTION: OP2 has Phonebook_entry in conference list with status ringing. Phonebook_entry being Out of Service, OP3 is receiving an invite to conference from OP2
@TEST_STEP_REF: [CATS-REF: i3Xv]
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
Then HMI OP2 verifies that popup phonebook is visible

Scenario: 4.1 OP2 changes call route selector to None
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None

Scenario: 4.2 OP2 types the destination name
Then HMI OP2 writes in phonebook text box: Test_Berta
And waiting for 1 second
When HMI OP2 selects phonebook entry number: 0

Scenario: 4.3 OP2 initiates the call
When HMI OP2 initiates a call from the phonebook
And waiting for 1 second

Scenario: 4.4 OP3 verifies calls queue section
Then HMI OP3 verify (via POST request) that call queue has status RINGING
!-- Then HMI OP3 has the call queue item OP2-OP3-Conf in state inc_initiated
!-- Then HMI OP3 has the call queue item OP2-OP3-Conf in the waiting list with name label CONF

Scenario: 4.5 OP2 verifies conference participants list
When HMI OP2 opens the conference participants list using call queue item OP1-OP2-CONF
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 3 has name Test_Berta
Then HMI OP2 verifies in the list that conference participant on position 3 has status ringing

Scenario: 4.6 OP2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: 5. OP3 accepts the call
Meta:
@TEST_STEP_ACTION: OP3 accepts the call 
@TEST_STEP_REACTION: Conference list contains OP1, OP2 and Phonebook_entry with status connected
@TEST_STEP_REF: [CATS-REF: HCUa]
When HMI OP3 answers (via POST request) CONF call by clicking on the queue
Then waiting for 1 seconds
!-- Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: 5.1 Vefifying OP3 calls queue section
Then HMI OP3 verify (via POST request) that call queue has status ESTABLISHED
Then HMI OP3 verify (via POST request) that call queue shows CONF
!-- Then HMI OP3 has the call queue item OP2-OP3-Conf in state connected
!-- Then HMI OP3 has the call queue item OP2-OP3-Conf in the active list with name label CONF
!-- Then HMI OP3 has the call queue item OP2-OP3-Conf in the active list with info label 3 participants

Scenario: 5.2 OP2 verifies conference participants list
When HMI OP2 opens the conference participants list using call queue item OP1-OP2-CONF
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP1_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP2_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name Test_Berta
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected

Scenario: 5.3 OP2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: 6. OP1 leaves the conference
Meta:
@TEST_STEP_ACTION: OP1 leaves the conference
@TEST_STEP_REACTION: OP1 has no calls in queue. Conference list contains OP2 and Phonebook_entry with status connected
@TEST_STEP_REF: [CATS-REF: KUFJ]
When HMI OP1 opens the conference participants list using call queue item OP2-OP1-Conf
Then HMI OP1 leaves conference
And waiting for 1 second
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 6.1 OP2 verifies conference participants list
When HMI OP2 opens the conference participants list using call queue item OP1-OP2-CONF
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP2_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name Test_Berta
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected

Scenario: 7. OP2 leaves the conference
Meta:
@TEST_STEP_ACTION: OP2 leaves the conference
@TEST_STEP_REACTION: OP2 and OP3 have no calls in queue
@TEST_STEP_REF: [CATS-REF: AjmD]
Then HMI OP2 leaves conference
And waiting for 1 second
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 7.1 OP3 verifies call queue section
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
