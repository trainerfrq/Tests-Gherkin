Narrative:
As a caller operator
I want to verify that if one Op Voice partition is down
The LSP state remains unchanged

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

Scenario: Op1 verifies loudspeaker initial state
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Verify displayed status
GivenStories: voice_GG/includes/StopStartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the display status section connection the state CONNECTED

Scenario: Caller activates loudspeaker
		  @REQUIREMENTS:GID-3005515
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Verify displayed status after the stopping the op voice instances from one partition
		  @REQUIREMENTS:GID-4034511
GivenStories: voice_GG/includes/StopOpVoiceActiveOnDockerHost2.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the display status section connection the state DEGRADED

Scenario: Op1 verifies that Loudspeaker state is unchanged
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Verify DA keys state
Given HMI OP1 has the DA key OP2(as OP1) in ready to be used state
Given HMI OP2 has the DA key OP1 in ready to be used state

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Op1 deactivates loudspeaker
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller activates loudspeaker
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Verify displayed status after the starting the op voice instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the display status section connection the state CONNECTED

Scenario: Op1 deactivates loudspeaker
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

