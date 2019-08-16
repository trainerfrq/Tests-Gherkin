Narrative:
As an operator
I want to count the number of phonebook entries
So I can check the total number of entries are available for the call

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Operator opens phonebook
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
Then HMI OP2 verifies that phone book call button is disabled
Then HMI OP2 verify that call route selector shows Default

Scenario: Operator checks if the phone book contains the specified number of entries
		  @REQUIREMENTS:GID-2877942
Given the totalNumber of phonebook entries from /configuration-files/<<systemName>>/phoneBook.json
Then HMI OP2 verifies that the total number of phonebook entries is totalNumber

Scenario: Operator closes phonebook
Then HMI OP2 closes phonebook popup

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
