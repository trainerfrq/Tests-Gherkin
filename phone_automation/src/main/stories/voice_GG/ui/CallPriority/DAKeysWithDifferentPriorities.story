Narrative:
As a caller operator having set a DAKey with requested Call Priority
I want to establish a phone call
So I can verify that the received call has the desired priority

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key              | source                | target                      | callType |
| OP3-Role1        | <<OP3_URI>>           | sip:role1@example.com       | DA/IDA   |
| Role1-OP3        | sip:role1@example.com | <<OP3_URI>>                 | DA/IDA   |
| OP1-OP2          | <<OP1_URI>>           | <<OP2_URI>>                 | DA/IDA   |
| OP2-OP1          | <<OP2_URI>>           | <<OP1_URI>>                 | DA/IDA   |
| OP1-OP3          | <<OP1_URI>>           | <<OP3_URI>>                 | DA/IDA   |
| OP3-OP1          | <<OP3_URI>>           | <<OP1_URI>>                 | DA/IDA   |
| OP3-OP1_uregent  | <<OP3_URI>>           | <<OP1_URI>>                 | DA/IDA   |
| OP1_uregent-OP3  | <<OP1_URI>>           | <<OP3_URI>>                 | DA/IDA   |

Scenario: Op3 checks DAKey priority
		  @REQUIREMENTS:GID-4698739
When HMI OP3 has the DA key ROLE1 with call priority EMERGENCY

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key ROLE1
Then HMI OP3 has the DA key ROLE1 in state out_ringing
Then HMI OP3 has the call queue item Role1-OP3 in state out_ringing

Scenario: Operator part of called role receive the incoming call
Then HMI OP1 has the call queue item OP3-Role1 in state inc_initiated

Scenario: Op1 client checks call priority
When HMI OP1 has the call queue item OP3-Role1 with priority EMERGENCY

Scenario: Op1 client answers the incoming call
Then HMI OP1 accepts the call queue item OP3-Role1

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item Role1-OP3 in state connected
Then HMI OP1 has the call queue item OP3-Role1 in state connected

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key ROLE1
And waiting for 1 second
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 checks DAKey priority
		  @REQUIREMENTS:GID-4698739
When HMI OP1 has the DA key OP2 with call priority NON-URGENT

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: Op2 receives the incoming call
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Op2 checks call priority
When HMI OP2 has the call queue item OP1-OP2 with priority NON-URGENT

Scenario: Op2 answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op1 clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op1
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 checks DAKey priority
	 @REQUIREMENTS:GID-4698739
When HMI OP1 has the DA key OP2 with call priority NORMAL

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: Op2 receives the incoming call
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Op2 checks call priority
When HMI OP2 has the call queue item OP1-OP2 with priority NORMAL

Scenario: Op2 answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op1 clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op1
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Verify operator mission
Then HMI OP3 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC

Scenario: Op3 changes its mission
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission EAST-EXEC-Test
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP3 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC-Test

Scenario: Op3 checks DAKey priority
		  @REQUIREMENTS:GID-4698739
When HMI OP3 has the DA key OP1-urgent with call priority URGENT

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP1-urgent
Then HMI OP3 has the DA key OP1-urgent in state out_ringing
Then HMI OP3 has the call queue item OP1_uregent-OP3 in state out_ringing

Scenario: Op1 client receives the incoming call
Then HMI OP1 has the call queue item OP3-OP1_uregent in state inc_initiated

Scenario: Op1 client checks call priority
When HMI OP1 has the call queue item OP3-OP1_uregent with priority URGENT

Scenario: Op1 client answers the incoming call
When HMI OP1 presses DA key OP3

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item OP1_uregent-OP3 in state connected
Then HMI OP1 has the call queue item OP3-OP1_uregent in state connected

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key OP1-urgent
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Verify operator mission
Then HMI OP3 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC-Test

Scenario: Op3 changes its mission
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission EAST-EXEC
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP3 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
