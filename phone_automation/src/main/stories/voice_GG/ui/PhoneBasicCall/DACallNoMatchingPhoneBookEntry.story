Narrative:
As a callee operator having an incoming call from a SIP contact
I want to have no matching entries for the caller SIP contact
So that I can verify that the SIP address will be displayed on the call queue item

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
| SipContact | VOIP    | anonymous   | <<SIP_PHONE3>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key            | source         | target                 | callType |
| SipContact-OP1 | <<SIP_PHONE3>> | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Callee client receives the incoming priority call
		  @REQUIREMENTS:GID-2877902
Then HMI OP1 has the call queue item SipContact-OP1 in state inc_initiated
Then HMI OP1 has the call queue item SipContact-OP1 in the waiting list with name label anonymous

Scenario: Sip phone clears calls
When SipContact terminates calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
