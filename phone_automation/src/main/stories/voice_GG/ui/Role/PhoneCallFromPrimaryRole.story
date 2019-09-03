Narrative:
As an operator
I want to initiate a call from phone book
So that I can verify that the call source is the primary role SIP address

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP1-OP3 | <<ROLE1_URI>>       | <<OPVOICE3_PHONE_URI>> | DA/IDA   |
| OP3-OP1 | <<OPVOICE3_PHONE_URI>> |                        | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
Then HMI OP1 verify that call route selector shows Default
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller selects item from phonebook
When HMI OP1 selects phonebook entry number: 5
Then HMI OP1 verifies that phone book text box displays text Lloyd
Then HMI OP1 verifies that phone book call button is enabled

Scenario: Caller initiates the call
When HMI OP1 initiates a call from the phonebook
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label Lloyd

Scenario: Verify that the call is initiated using the caller primary SIP address
		  @REQUIREMENTS:GID-2952544
Then HMI OP3 has the call queue item OP1-OP3 in the waiting list with name label <<ROLE_1_NAME>>

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP3-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
