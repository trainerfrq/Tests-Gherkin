Narrative:
As an operator that has an active DA priority call
I want to change mission
So I can check that all the call attributes are not affected by this change

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

Scenario: Caller establishes an outgoing priority call
When HMI OP1 initiates a priority call on DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Callee client receives the incoming priority call
Then HMI OP2 has the DA key OP1 in state ringing
Then HMI OP2 has in the call queue the item OP1-OP2 with priority

Scenario: Change mission for HMI OP2 and verify call state for both operators
		  @REQUIREMENTS: QXVP-XVP_SSS-740
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission 1
Then HMI OP2 press button Activate Mission
Then waiting for 5 seconds
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state ringing
Then HMI OP2 has in the call queue the item OP1-OP2 with priority

Scenario: Callee client answers the incoming priority call
Then HMI OP2 accepts the call queue item OP1-OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Change mission for HMI OP1 and verify call state for both operators
		  @REQUIREMENTS: QXVP-XVP_SSS-740
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission 0
Then HMI OP1 press button Activate Mission
Then waiting for 5 seconds
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP1 has in the call queue the item OP2-OP1 with priority

Scenario: Callee terminates call
Then HMI OP2 terminates the call queue item OP1-OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls
