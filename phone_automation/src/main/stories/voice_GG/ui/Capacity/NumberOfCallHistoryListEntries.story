Narrative:
As an operator
I want to establish 101 calls
So I can check that the call history list supports up to 100 calls

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Caller clears call history list
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY
Then HMI OP2 clears Call History list
Then HMI OP2 verifies that call history list contains 0 entries
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes 100 outgoing calls towards same target
When HMI OP2 presses for 200 times the DA key OP1
Then wait for 2 seconds

Scenario: Verify call is terminated for both operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Caller opens call history
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY

Scenario: Caller verifies the call history list
Then HMI OP2 verifies that call history list contains 100 entries
When HMI OP2 selects call history list entry number: 0
Then HMI OP2 verifies that call history call button has label <<OP1_NAME>>
When HMI OP2 selects call history list entry number: 1
Then HMI OP2 verifies that call history call button has label <<OP1_NAME>>
When HMI OP2 selects call history list entry number: 2
Then HMI OP2 verifies that call history call button has label <<OP1_NAME>>

Scenario: Caller closes call history
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes the 101st call
When HMI OP2 presses DA key OP3

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP3
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Caller opens call history
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY

Scenario: Caller verifies that the call history list still has 100 entries
		  @REQUIREMENTS:GID-2600304
Then HMI OP2 verifies that call history list contains 100 entries

Scenario: Caller verifies that the last call is in call history list
When HMI OP2 selects call history list entry number: 0
Then HMI OP2 verifies that call history call button has label <<OP3_NAME>>

Scenario: Caller clears call history list
		  @REQUIREMENTS:GID-4695014
Then HMI OP2 clears Call History list
Then HMI OP2 verifies that call history list contains 0 entries
Then HMI OP2 closes Call History popup window

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond



