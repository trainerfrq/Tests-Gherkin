Narrative:
As an operator
I want read the call history list
So I can check that the call history list is time sorted

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                 | target                 | callType |
| OP2-OP1   | <<OP2_URI>> | <<OP1_URI>>              | DA/IDA   |
| OP2-OP3   | <<OP2_URI>> | <<OP3_URI>>              | DA/IDA   |
| OP2-Role1 | <<OP2_URI>> | sip:role1@example.com | DA/IDA   |

Scenario: Caller clears call history list
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY
Then HMI OP2 clears Call History list
Then HMI OP2 verifies that call history list contains 0 entries
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes an outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP1 has the DA key OP2 in state inc_initiated

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP1

Scenario: Caller establishes an another outgoing call
When HMI OP2 presses DA key OP3
Then HMI OP2 has the DA key OP3 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP3 has the DA key OP2 in state inc_initiated

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP3

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Op2 receive the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Caller clears outgoing call
When HMI OP1 presses DA key OP2

Scenario: Verify call is terminated for both operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op2 opens call history
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY

Scenario: Op2 verifies that call history entries are ordered by time
            @REQUIREMENTS:GID-3225206
Then HMI OP2 verifies that call history list contains 3 entries
Then HMI OP2 using format <<dateFormat>> verifies call history list is time-sorted

Scenario: Op2 closes call history
Then HMI OP2 closes Call History popup window

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
