Narrative:
As an operator
I want to initiate an outgoing DA call with the Dial Pad using ATS telephone number
So I can check that the outgoing call is initiated

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source           | target      | callType |
| OP1-OP2 | <<ROLE1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | 222222           |             | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
Then HMI OP1 verify that call route selector shows Default
Then HMI OP1 verifies that phone book call button is disabled
Then HMI OP1 verifies that phone book priority toggle is inactive

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: 222222
Then HMI OP1 verifies that phone book call button is enabled

Scenario: Caller toggles call priority
		  @REQUIREMENTS:GID-3827803
When HMI OP1 toggles call priority
Then HMI OP1 verifies that phone book priority toggle is active

Scenario: Caller hits phonebook call button
		  @REQUIREMENTS:GID-2535727
		  @REQUIREMENTS:GID-2535740
		  @REQUIREMENTS:GID-2536683
		  @REQUIREMENTS:GID-2536682
When HMI OP1 initiates a call from the phonebook
Then waiting for 1 second

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP1 verifies that call queue item bar signals call state priority
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated
Then HMI OP2 verifies that call queue item bar signals call state priority
Then HMI OP2 has the call queue item OP1-OP2 in the priority list with name label <<ROLE_1_NAME>>
!-- Known bug QXVP-14392
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
