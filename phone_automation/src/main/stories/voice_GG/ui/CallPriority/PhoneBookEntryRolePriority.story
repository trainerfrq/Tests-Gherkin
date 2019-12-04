Narrative:
As an operator
I want to establish a call to a Phone Book Entry that has set Priority to: Use Role Priority
So I can verify that the call has the priority of the active role

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
| OP2-SipContact | <<SIP_PHONE6>>  |           | DA/IDA   |

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: Op2 opens PhoneBook
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK

Scenario: Op2 changes Call Route Selector to None
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None

Scenario: Op2 searches for desired phone book entry
When HMI OP2 writes in phonebook text box: Test_Mcintyre
Then HMI OP2 verifies that phonebook list has 1 items

Scenario: Op2 does a call from phone book
When HMI OP2 selects phonebook entry number: 0
When HMI OP2 initiates a call from the phonebook
And waiting for 1 second

Scenario: Sip Contact answers call
When SipContact answers incoming calls

Scenario: Op2 checks call priority
		  @REQUIREMENTS:GID-2659402
When HMI OP2 has the call queue item OP2-SipContact with priority NORMAL

Scenario: Call is initiated
Then HMI OP2 has the call queue item OP2-SipContact in the active list with name label Test_Mcintyre

Scenario: SipContact clears outgoing call
When SipContact terminates calls

Scenario: Call is terminated
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: Op2 changes its mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_4_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_4_NAME>>

Scenario: Op2 opens PhoneBook
When HMI OP2 with layout <<LAYOUT_MISSION4>> presses function key PHONEBOOK

Scenario: Op2 changes Call Route Selector to None
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None

Scenario: Op2 searches for desired phone book entry
When HMI OP2 writes in phonebook text box: Test_Mcintyre
Then HMI OP2 verifies that phonebook list has 1 items

Scenario: Op2 does a call from phone book
When HMI OP2 selects phonebook entry number: 0
When HMI OP2 initiates a call from the phonebook
And waiting for 1 second

Scenario: Sip Contact answers call
When SipContact answers incoming calls

Scenario: Op2 checks call priority
		  @REQUIREMENTS:GID-2659402
When HMI OP2 has the call queue item OP2-SipContact with priority EMERGENCY

Scenario: Call is initiated
Then HMI OP2 has the call queue item OP2-SipContact in the active list with name label Test_Mcintyre

Scenario: SipContact clears outgoing call
When SipContact terminates calls
And waiting for 1 second

Scenario: Call is terminated
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: Clean-up Op2 changes its mission back
When HMI OP2 with layout <<LAYOUT_MISSION4>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
