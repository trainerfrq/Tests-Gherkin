Narrative:
As an operator
I want to establish a call to a Phone Book Entry that has set Priority to: Use Role Priority
So I can verify that the call has the priority of my operator role

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
| SipContact | VOIP    | 656750       | <<SIP_PHONE6>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key            | source          | target    | callType |
| OP3-SipContact | <<SIP_PHONE6>>  |           | DA/IDA   |

Scenario: Verify operator mission
Then HMI OP3 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC

Scenario: Op3 changes its mission
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission EAST-EXEC-Test
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP3 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC-Test

Scenario: Op3 opens PhoneBook
When HMI OP3 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK

Scenario: Op3 changes Call Route Selector to None
When HMI OP3 selects call route selector: none
Then HMI OP3 verify that call route selector shows None

Scenario: Op3 searches for desired phone book entry
When HMI OP3 writes in phonebook text box: Test_Mcintyre
Then HMI OP3 verifies that phonebook list has 1 items

Scenario: Op3 does a call from phone book
When HMI OP3 selects phonebook entry number: 0
When HMI OP3 initiates a call from the phonebook
And waiting for 1 second

Scenario: Sip Contact answers call
When SipContact answers incoming calls

Scenario: Op1 checks call priority
		  @REQUIREMENTS:GID-2659402
When HMI OP3 has the call queue item OP3-SipContact with priority EMERGENCY

Scenario: Call is initiated
Then HMI OP3 has the call queue item OP3-SipContact in the active list with name label Test_Mcintyre

Scenario: Op1 clears outgoing call
When SipContact terminates calls
!-- Then HMI OP3 terminates the call queue item SipContact-OP3

Scenario: Call is terminated
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: Clean-up Op3 changes its mission back
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission EAST-EXEC
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP3 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
