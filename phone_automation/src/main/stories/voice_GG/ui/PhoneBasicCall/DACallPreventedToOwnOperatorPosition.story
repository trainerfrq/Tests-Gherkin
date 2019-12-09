Narrative:
As a caller operator
I want to initiate an outgoing DA call to my own operator position
So I can verify that there is no incoming call on my operator position

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target | callType |
| OP1-OP1 | <<OPVOICE1_PHONE_URI>> |        | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK

Scenario: Caller selects target address
When HMI OP1 clicks on the scroll down button in phonebook for 1 time(s)
When HMI OP1 selects phonebook entry number: 10
Then HMI OP1 verifies that phone book text box displays text OP1 Physical

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Verify call is received and call status is failed
		  @REQUIREMENTS:GID-2535698
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item OP1-OP1 in state out_failed

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP1-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting for 1 millisecond
