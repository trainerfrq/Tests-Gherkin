Narrative:
As an operator
I want to establish a call to a Phone Book Entry that has set Priority to: EMERGENCY
So I can verify that the call has priority: EMERGENCY

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
| SipContact | VOIP    | 946416      | <<SIP_PHONE5>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key             | source          | target    | callType |
| OP1-SipContact  | <<SIP_PHONE5>>  |           | DA/IDA   |

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: Op1 opens PhoneBook
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK

Scenario: Op1 changes Call Route Selector to None
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None

Scenario: Op1 searches for desired phone book entry
When HMI OP1 writes in phonebook text box: Test_Pace
And waiting for 1 second

Scenario: Op1 does a call from phone book
When HMI OP1 selects phonebook entry number: 0
When HMI OP1 initiates a call from the phonebook
And waiting for 1 second

Scenario: Sip Contact answers call
When SipContact answers incoming calls

Scenario: Op1 checks call priority
		  @REQUIREMENTS:GID-2659402
When HMI OP1 has the call queue item OP1-SipContact with priority EMERGENCY

Scenario: Op1 verifies call queue item label
Then HMI OP1 has the call queue item OP1-SipContact in the active list with name label Test_Pace

Scenario: Op1 clears outgoing call
Then HMI OP1 terminates the call queue item OP1-SipContact

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 changes its mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_3_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_3_NAME>>

Scenario: Op1 opens PhoneBook
When HMI OP1 with layout <<LAYOUT_MISSION3>> presses function key PHONEBOOK

Scenario: Op1 changes Call Route Selector to None
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None

Scenario: Op1 searches for desired phone book entry
When HMI OP1 writes in phonebook text box: Test_Pace
And waiting for 1 second

Scenario: Op1 does a call from phone book
When HMI OP1 selects phonebook entry number: 0
When HMI OP1 initiates a call from the phonebook
And waiting for 1 second

Scenario: Sip Contact answers call
When SipContact answers incoming calls

Scenario: Op1 checks call priority
		  @REQUIREMENTS:GID-2659402
When HMI OP1 has the call queue item OP1-SipContact with priority EMERGENCY

Scenario: Verify call label
Then HMI OP1 has the call queue item OP1-SipContact in the active list with name label Test_Pace

Scenario: Op1 clears outgoing call
Then HMI OP1 terminates the call queue item OP1-SipContact

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 changes its mission back
When HMI OP1 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
