Narrative:
As an operator
I want to initiate an outgoing DA call by clicking on one telephone book entry
So I can check that the call towards the corresponding entry is initiated

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP1-OP2 | <<ROLE1_URI>>          | <<OPVOICE2_PHONE_URI>> | DA/IDA   |
| OP2-OP1 | <<OPVOICE2_PHONE_URI>> |                        | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
		  @REQUIREMENTS:GID-2985359
Then HMI OP1 verify that call route selector shows Default
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller selects item from phonebook
When HMI OP1 scrolls down in phonebook
When HMI OP1 selects phonebook entry number: 11
Then HMI OP1 verifies that phone book text box displays text OP2 Physical
Then HMI OP1 verifies that phone book call button is enabled
Then HMI OP1 verifies that phone book priority toggle is inactive

Scenario: Caller toggles priority
		  @REQUIREMENTS:GID-3827803
When HMI OP1 toggles call priority
Then HMI OP1 verifies that phone book priority toggle is active

Scenario: Caller hits phonebook call button
		  @REQUIREMENTS:GID-2535749
		  @REQUIREMENTS:GID-2535757
		  @REQUIREMENTS:GID-2536682
When HMI OP1 initiates a call from the phonebook

Scenario: Priority call is initiated
		  @REQUIREMENTS:GID-2932446
		  @REQUIREMENTS:GID-2535740
Then HMI OP1 has in the call queue the item OP2-OP1 with priority
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label OP2 Physical
Then HMI OP2 has the call queue item OP1-OP2 in the priority list with name label <<ROLE_1_NAME>>

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
