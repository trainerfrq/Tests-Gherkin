Narrative:
As an operator
I want to establish a call to a Phone Book Entry that has set Priority to: NORMAL
So I can verify that the call has priority: NORMAL

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 111173      | <<SIP_PHONE4>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key             | source          | target    | callType |
| OP1-SipContact | <<SIP_PHONE4>>  |           | DA/IDA   |

Scenario: Op1 opens PhoneBook
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK

Scenario: Op1 changes Call Route Selector to None
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None

Scenario: Op1 searches for desired phone book entry
When HMI OP1 writes in phonebook text box: Test_Bettie
And waiting for 1 second

Scenario: Op1 does a call from phone book
When HMI OP1 selects phonebook entry number: 0
When HMI OP1 initiates a call from the phonebook

Scenario: Op1 checks call priority
		  @REQUIREMENTS:GID-2659402
When HMI OP1 has the call queue item OP1-SipContact with priority NORMAL

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP1-SipContact in the active list with name label Test_Bettie

Scenario: Op1 clears outgoing call
Then HMI OP1 terminates the call queue item OP1-SipContact

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
