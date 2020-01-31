Meta:
@TEST_CASE_VERSION: V10
@TEST_CASE_NAME: CCF rule with max number of destinations
@TEST_CASE_DESCRIPTION: As an operator having set 20 destinations for a Conditional Call Forward Rule
I want to establish a call to each set destination
So I can verify that the rule is applied for each destination
@TEST_CASE_PRECONDITION: Settings:
A Conditional Call Forward rule is set with:
- matching call destination: 20 phonebook entries
- forward calls on:                        *out of service: OP3                        *reject: no call forwarding                        *no reply: no call forwarding
-number of rule iterations: 0
The phonebook entries are Out of Service.
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if the call to each destination is forwarded to OP3
@TEST_CASE_DEVICES_IN_USE:
@TEST_CASE_ID: PVCSX-TC-11886
@TEST_CASE_GLOBAL_ID: GID-5154346
@TEST_CASE_API_ID: 17689047

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key               | source                   | target                   | callType |
| OP2-SipContact1   | sip:134656@example.com   |                          | DA/IDA   |
| SipContact1-OP3   | <<ROLE2_URI>>            | sip:134656@example.com   | DA/IDA   |
| OP2-SipContact2   | sip:359470@example.com   |                          | DA/IDA   |
| SipContact2-OP3   | <<ROLE2_URI>>            | sip:359470@example.com   | DA/IDA   |
| OP2-SipContact3   | sip:703259@example.com   |                          | DA/IDA   |
| SipContact3-OP3   | <<ROLE2_URI>>            | sip:703259@example.com   | DA/IDA   |
| OP2-SipContact4   | sip:142722@example.com   |                          | DA/IDA   |
| SipContact4-OP3   |  <<ROLE2_URI>>           | sip:142722@example.com   | DA/IDA   |
| OP2-SipContact5   | sip:832315@example.com   |                          | DA/IDA   |
| SipContact5-OP3   |  <<ROLE2_URI>>           | sip:832315@example.com   | DA/IDA   |
| OP2-SipContact6   | sip:622286@example.com   |                          | DA/IDA   |
| SipContact6-OP3   |  <<ROLE2_URI>>           | sip:622286@example.com   | DA/IDA   |
| OP2-SipContact7   | sip:676294@example.com   |                          | DA/IDA   |
| SipContact7-OP3   | <<ROLE2_URI>>            | sip:676294@example.com   | DA/IDA   |
| OP2-SipContact8   | sip:443415@example.com   |                          | DA/IDA   |
| SipContact8-OP3   | <<ROLE2_URI>>            | sip:443415@example.com   | DA/IDA   |
| OP2-SipContact9   | sip:786587@example.com   |                          | DA/IDA   |
| SipContact9-OP3   | <<ROLE2_URI>>            | sip:786587@example.com   | DA/IDA   |
| OP2-SipContact10  | sip:957974@example.com   |                          | DA/IDA   |
| SipContact10-OP3  | <<ROLE2_URI>>            | sip:957974@example.com   | DA/IDA   |
| OP2-SipContact11  | sip:792024@example.com   |                          | DA/IDA   |
| SipContact11-OP3  | <<ROLE2_URI>>            | sip:792024@example.com   | DA/IDA   |
| OP2-SipContact12  | sip:241821@example.com   |                          | DA/IDA   |
| SipContact12-OP3  | <<ROLE2_URI>>            | sip:241821@example.com   | DA/IDA   |
| OP2-SipContact13  | sip:356704@example.com   |                          | DA/IDA   |
| SipContact13-OP3  | <<ROLE2_URI>>            | sip:356704@example.com   | DA/IDA   |
| OP2-SipContact14  | sip:438047@example.com   |                          | DA/IDA   |
| SipContact14-OP3  | <<ROLE2_URI>>            | sip:438047@example.com   | DA/IDA   |
| OP2-SipContact15  | sip:971529@example.com   |                          | DA/IDA   |
| SipContact15-OP3  | <<ROLE2_URI>>            | sip:971529@example.com   | DA/IDA   |
| OP2-SipContact16  | sip:238016@example.com   |                          | DA/IDA   |
| SipContact16-OP3  | <<ROLE2_URI>>            | sip:238016@example.com   | DA/IDA   |
| OP2-SipContact17  | sip:341606@example.com   |                          | DA/IDA   |
| SipContact17-OP3  | <<ROLE2_URI>>            | sip:341606@example.com   | DA/IDA   |
| OP2-SipContact18  | sip:264648@example.com   |                          | DA/IDA   |
| SipContact18-OP3  | <<ROLE2_URI>>            | sip:264648@example.com   | DA/IDA   |
| OP2-SipContact19  | sip:320546@example.com   |                          | DA/IDA   |
| SipContact19-OP3  | <<ROLE2_URI>>            | sip:320546@example.com   | DA/IDA   |
| OP2-SipContact20  | sip:848138@example.com   |                          | DA/IDA   |
| SipContact20-OP3  | <<ROLE2_URI>>            | sip:848138@example.com   | DA/IDA   |
| OP2-SipContact21  | sip:931803@example.com   |                          | DA/IDA   |
| SipContact21-OP3  | <<ROLE2_URI>>            | sip:931803@example.com   | DA/IDA   |

Scenario: 20 destinations Conditional Call Forward rule
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
Then HMI OP2 verifies that popup phonebook is visible
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None
Then HMI OP2 writes in phonebook text box: <address>
And waiting for 1 second
When HMI OP2 selects phonebook entry number: 0
When HMI OP2 initiates a call from the phonebook
And waiting for 1 second
Then HMI OP2 has the call queue item <callQueueItem1> in state out_ringing
Then HMI OP2 has the call queue item <callQueueItem1> in the active list with name label <address>
Then HMI OP3 has the call queue item <callQueueItem2> in the waiting list with name label <<ROLE_2_NAME>>
Then HMI OP2 terminates the call queue item <callQueueItem1>
Then HMI OP2 has in the call queue a number of 0 calls

Examples:
| address          | callQueueItem1   | callQueueItem2    |
| Test_Berta       | OP2-SipContact1  | SipContact1-OP3   |
| Test_Ladonna     | OP2-SipContact2  | SipContact2-OP3   |
| Test_Frye        | OP2-SipContact3  | SipContact3-OP3   |
| Test_Ronda       | OP2-SipContact4  | SipContact4-OP3   |
| Test_Lancaster   | OP2-SipContact5  | SipContact5-OP3   |
| Test_Yates       | OP2-SipContact6  | SipContact6-OP3   |
| Test_Alfreda     | OP2-SipContact7  | SipContact7-OP3   |
| Test_Parrish     | OP2-SipContact8  | SipContact8-OP3   |
| Test_Shelia      | OP2-SipContact9  | SipContact9-OP3   |
| Test_Myra        | OP2-SipContact10 | SipContact10-OP3  |
| Test_Dunn        | OP2-SipContact11 | SipContact11-OP3  |
| Test_Lester      | OP2-SipContact12 | SipContact12-OP3  |
| Test_Lopez       | OP2-SipContact13 | SipContact13-OP3  |
| Test_Melody      | OP2-SipContact14 | SipContact14-OP3  |
| Test_Watkins     | OP2-SipContact15 | SipContact15-OP3  |
| Test_Dale        | OP2-SipContact16 | SipContact16-OP3  |
| Test_Rosetta     | OP2-SipContact17 | SipContact17-OP3  |
| Test_Cotton      | OP2-SipContact18 | SipContact18-OP3  |
| Test_Villarreal  | OP2-SipContact19 | SipContact19-OP3  |
| Test_Gomez       | OP2-SipContact20 | SipContact20-OP3  |

Scenario: Phonebook entry 21
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
Then HMI OP2 verifies that popup phonebook is visible
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None
When HMI OP2 writes in phonebook text box: Test_Hinton
And waiting for 1 second
When HMI OP2 selects phonebook entry number: 0
When HMI OP2 initiates a call from the phonebook
And waiting for 1 second
Then HMI OP2 has the call queue item OP2-SipContact21 in state out_failed
Then HMI OP2 has the call queue item OP2-SipContact21 in the active list with name label Test_Hinton
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP2 terminates the call queue item OP2-SipContact21
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
