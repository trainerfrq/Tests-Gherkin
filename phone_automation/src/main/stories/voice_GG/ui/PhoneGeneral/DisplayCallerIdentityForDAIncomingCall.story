Narrative:
As a caller operator
I want to establish an outgoing DA call
So I can verify that the caller identity for the incoming call is displayed.

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target              | callType |
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | DA/IDA   |

Scenario: Caller establishes an outgoing call
When HMI OP2 presses DA key OP3

Scenario: Callee client receives the incoming call with the identity of the caller
		  @REQUIREMENTS:GID-3547601
Then HMI OP3 has the call queue item OP2-OP3 in the waiting list with name label <<OP2_NAME>>

Scenario: Callee client answers the incoming call
When HMI OP3 presses DA key OP2

Scenario: Verify call is connected and the caller identity is displayed
Then HMI OP3 has the call queue item OP2-OP3 in the active list with name label <<OP2_NAME>>

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP3

Scenario: Call is terminated for both
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Caller selects first entry from history
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY
When HMI OP2 selects call history list entry number: 0

Scenario: Caller verifies the label on call history button
Then HMI OP2 verifies that call history call button has label <<OP3_NAME>>

Scenario: Caller hits call history call button
When HMI OP2 initiates a call from the call history

Scenario: Callee client receives the incoming call
Then HMI OP3 has the call queue item OP2-OP3 in the waiting list with name label <<OP2_NAME>>

Scenario: Callee client answers the incoming call
When HMI OP3 presses DA key OP2

Scenario: Verify call is connected and the caller identity is displayed
Then HMI OP3 has the call queue item OP2-OP3 in the active list with name label <<OP2_NAME>>

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP3

Scenario: Call is terminated for both
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls
