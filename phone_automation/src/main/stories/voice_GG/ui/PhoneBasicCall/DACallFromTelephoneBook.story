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
| OP1-OP3 | <<ROLE1_URI>>       | <<OPVOICE3_PHONE_URI>> | DA/IDA   |
| OP3-OP1 | <<OPVOICE3_PHONE_URI>> |                        | DA/IDA   |

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
When HMI OP1 selects phonebook entry number: 5
Then HMI OP1 verifies that phone book text box displays text Lloyd
Then HMI OP1 verifies that phone book call button is enabled

Scenario: Caller hits phonebook call button
		  @REQUIREMENTS:GID-2535749
		  @REQUIREMENTS:GID-2536683
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
		  @REQUIREMENTS:GID-2932446
		  @REQUIREMENTS:GID-2536683
		  @REQUIREMENTS:GID-2535740
		  @REQUIREMENTS:GID-3366402
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label Lloyd
Then HMI OP3 has the call queue item OP1-OP3 in the waiting list with name label <<ROLE_1_NAME>>

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP3-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
