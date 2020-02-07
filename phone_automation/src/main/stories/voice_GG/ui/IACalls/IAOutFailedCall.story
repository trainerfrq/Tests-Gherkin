Narrative:
As an operator
I want to initiate an outgoing IA call towards a SIP contact not answering automatically to the IA call invite
So that I can verify that after the IA call timeout expires the call will be in state out_failed

Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host           | identifier |
| javafx              | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx              | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx              | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key        | source         | target      | callType |
| OP1-PHONE2 | <<SIP_PHONE2>> | <<OP1_URI>> | IA       |

Scenario: Caller establishes an outgoing IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key Madoline
Then HMI OP1 has the call queue item OP1-PHONE2 in state out_initiating

Scenario: SipContact has incoming call
Then SipContact DialogState is EARLY within 100 ms

Scenario: Wait until timer expires and verify if call is out_failed
		  @REQUIREMENTS:GID-2505705
When waiting for 6 seconds
Then HMI OP1 has the call queue item OP1-PHONE2 in state out_failed

Scenario: Cleanup IA call
When HMI OP1 presses IA key Madoline
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Caller establishes an outgoing IA call
When HMI OP1 presses IA key Madoline
Then HMI OP1 has the call queue item OP1-PHONE2 in state out_initiating

Scenario: SipContact has incoming call
Then SipContact DialogState is EARLY within 100 ms

Scenario: Wait until timer expires and verify if call is out_failed
When waiting for 6 seconds
Then HMI OP1 has the call queue item OP1-PHONE2 in state out_failed

Scenario: Wait until call is terminated automatically
When waiting for 15 seconds
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove SipContact
When SipContact is removed

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
