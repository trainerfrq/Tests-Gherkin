Narrative:
As a caller operator having an active DA priority call with a callee operator
I want to verify that if one Op Voice partition is down
The active call will be automatically terminated, but one new DA priority call can be made

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

Scenario: Verify displayed status after stopping and starting op voice instances from one partition
GivenStories: voice_GG/includes/StopStartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the display status section connection the state CONNECTED
Then HMI OP2 has in the display status section connection the state CONNECTED

Scenario: Verify displayed status after the stopping the op voice instances from one partition
GivenStories: voice_GG/includes/StopOpVoiceActiveOnDockerHost2.story
Then HMI OP1 has in the display status section connection the state DISCONNECTED
Then HMI OP2 has in the display status section connection the state DISCONNECTED

Scenario: Verify displayed status after the stopping the op voice instances from one partition
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the display status section connection the state DEGRADED
When HMI OP2 verifies that loading screen is visible
Then HMI OP2 has in the display status section connection the state DEGRADED

Scenario: Verify DA keys state
Given HMI OP1 has the DA key OP2(as OP1) in ready to be used state
Given HMI OP2 has the DA key OP1 in ready to be used state

Scenario: Callee client receives the incoming priority call
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Callee client receives the incoming priority call
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has in the call queue the item OP1-OP2 with priority

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP2-OP1 in the active list with label OP2(as OP1)
Then HMI OP2 has the call queue item OP1-OP2 in the priority list with label 111111

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP2-OP1 in the active list with label OP2(as OP1)
Then HMI OP2 has the call queue item OP1-OP2 in the active list with label 111111

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the display status section connection the state CONNECTED
Then HMI OP2 has in the display status section connection the state CONNECTED

Scenario: Verify displayed status after the stopping the op voice instances from one partition
		  @REQUIREMENTS:GID-4034511
GivenStories: voice_GG/includes/StopOpVoiceActiveOnDockerHost1.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the display status section connection the state DEGRADED
When HMI OP2 verifies that loading screen is visible
Then HMI OP2 has in the display status section connection the state DEGRADED

Scenario: Call is terminated for callee
!-- TODO QXVP-9245 : enable this test after story is done
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Verify DA keys state
Given HMI OP1 has the DA key OP2(as OP1) in ready to be used state
Given HMI OP2 has the DA key OP1 in ready to be used state

Scenario: Caller establishes an outgoing priority  call
When HMI OP1 initiates a priority call on DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the display status section connection the state CONNECTED
Then HMI OP2 has in the display status section connection the state CONNECTED
