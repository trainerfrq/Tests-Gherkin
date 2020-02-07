Narrative:
As an operator
I want to initiate an outgoing DA call with the Dial Pad using alphanumeric address
So I can check that the outgoing call is initiated

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
| key            | source     | target | callType |
| OP1-SipContact | <<PHONE2>> |        | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP2 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
		  @REQUIREMENTS:GID-2985359
Then HMI OP2 verify that call route selector shows Default
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None
Then HMI OP2 verifies that phone book call button is disabled
Then HMI OP2 verifies that phone book priority toggle is inactive

Scenario: Caller writes target address in text box
When HMI OP2 writes in phonebook text box the address: <<PHONE2>>
Then HMI OP2 verifies that phone book call button is enabled

Scenario: Caller toggles call priority
		  @REQUIREMENTS:GID-3827803
When HMI OP2 toggles call priority
Then HMI OP2 verifies that phone book priority toggle is active

Scenario: Caller hits phonebook call button
		  @REQUIREMENTS:GID-4020711
		  @REQUIREMENTS:GID-2535740
		  @REQUIREMENTS:GID-2536683
		  @REQUIREMENTS:GID-2536682
When HMI OP2 initiates a call from the phonebook

Scenario: Call is initiated
		  @REQUIREMENTS:GID-2535717
Then HMI OP2 has the call queue item OP1-SipContact in state out_ringing
Then HMI OP2 verifies that call queue item bar signals call state priority
!-- Then HMI OP2 has the call queue item OP1-SipContact in the active list with name label Madoline
!-- TODO Enable test when bug QXVP-14392 is fixed

Scenario: Sip Contact answers call
When SipContact answers incoming calls

Scenario: Verify call on caller side
Then HMI OP2 verifies that call queue item bar signals call state priority
Then HMI OP2 has the call queue item OP1-SipContact in the active list with name label Madoline

Scenario: Caller clears outgoing call
Then HMI OP2 terminates the call queue item OP1-SipContact

Scenario: Call is terminated
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
