Narrative:
As an operator
I want to change mission and initiate an outgoing DA call by clicking on a previous outgoing call's history entry
So I can check that the call towards the corresponding entry is initiated with the same attributes as the previous call

Meta: @AfterStory: ../includes/@SwitchToInitialMission.story

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP1-OP2 | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1 | sip:222222@example.com | sip:111111@example.com | DA/IDA   |

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2(as OP1)
Then waiting for 3 seconds
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the DA key OP2(as OP1) in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the DA key OP1 in state connected

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Change mission for HMI OP1
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Caller opens call history
When HMI OP1 presses function key CALLHISTORY

Scenario: Caller selects first entry from history
When HMI OP1 selects call history list entry number: 0
Then HMI OP1 verifies that call history call button has label OP2(as OP1)
!-- TODO QXVP-11374 : re-enable this step after bug is fixed
!-- Then HMI OP1 verifies that call history redial button is enabled

Scenario: Caller does call from call history
		  @REQUIREMENTS:GID-2535764
		  @REQUIREMENTS:GID-4084452
When HMI OP1 initiates a call from the call history
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in the waiting list with label 111111

Scenario: Callee client answers the incoming call
Then HMI OP2 accepts the call queue item OP1-OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the DA key OP1 in state connected

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls
Then waiting for 2 seconds
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Change mission for HMI OP2
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Caller opens call history
When HMI OP1 presses function key CALLHISTORY

Scenario: Caller selects first entry from history
When HMI OP1 selects call history list entry number: 0
Then HMI OP1 verifies that call history call button has label OP2(as OP1)
Then HMI OP1 verifies that call history dial button is enabled

Scenario: Caller does call from call history
		  @REQUIREMENTS:GID-2535764
		  @REQUIREMENTS:GID-4084452
		  @REQUIREMENTS:GID-4084452
When HMI OP1 initiates a call from the call history
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in the waiting list with label 111111
Then HMI OP1 has the call queue item OP2-OP1 in the active list with label OP2 Physical

Scenario: Callee client answers the incoming call
Then HMI OP2 accepts the call queue item OP1-OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Clear call
Then HMI OP1 terminates the call queue item OP2-OP1
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
