Narrative:
As a caller operator having set a DAKey with Call Priority: ROLE
I want to establish a phone call
So I can verify that the received call has caller's operator role priority

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key                  | source                         | target                         | callType |
| OP3-RoleEmergency    | <<OP3_URI>>                    | sip:roleEmergency@example.com  | DA/IDA   |
| RoleEmergency-OP3    |sip:roleEmergency@example.com   | <<OP3_URI>>                    | DA/IDA   |

Scenario: Verify operator mission
Then HMI OP3 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC

!-- passes while UPPER-EAST-EXEC role Default SIP Priority: NON-URGENT
Scenario: Op3 checks DAKey priority
		  @REQUIREMENTS:GID-4698739
When HMI OP3 has the DA key RoleEmergency with call priority NON-URGENT

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key RoleEmergency
Then HMI OP3 has the DA key RoleEmergency in state out_ringing
Then HMI OP3 has the call queue item RoleEmergency-OP3 in state out_ringing

Scenario: Operators part of called role receive the incoming call
Then HMI OP1 has the call queue item OP3-RoleEmergency in state inc_initiated
Then HMI OP2 has the call queue item OP3-RoleEmergency in state inc_initiated

Scenario: Op1 answers the incoming call
Then HMI OP1 accepts the call queue item OP3-RoleEmergency

Scenario: Op3 checks call priority
When HMI OP3 has the call queue item RoleEmergency-OP3 with priority NON-URGENT

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item RoleEmergency-OP3 in state connected
Then HMI OP1 has the call queue item OP3-RoleEmergency in state connected

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key RoleEmergency
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op3 changes its mission
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission EAST-EXEC-Test
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP3 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC-Test

!-- passes while UPPER-EAST-EXEC-Test role Default SIP Priority: EMERGENCY
Scenario: Op3 checks DAKey priority
		  @REQUIREMENTS:GID-4698739
When HMI OP3 has the DA key RoleEmergency with call priority EMERGENCY

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key RoleEmergency
Then HMI OP3 has the DA key RoleEmergency in state out_ringing
Then HMI OP3 has the call queue item RoleEmergency-OP3 in state out_ringing

Scenario: Operators part of called role receive the incoming call
Then HMI OP1 has the call queue item OP3-RoleEmergency in state inc_initiated
Then HMI OP2 has the call queue item OP3-RoleEmergency in state inc_initiated

Scenario: Op1 answers the incoming call
Then HMI OP1 accepts the call queue item OP3-RoleEmergency

Scenario: Op3 checks call priority
When HMI OP3 has the call queue item RoleEmergency-OP3 with priority EMERGENCY

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item RoleEmergency-OP3 in state connected
Then HMI OP1 has the call queue item OP3-RoleEmergency in state connected

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key RoleEmergency
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Clean-up: Op3 changes its mission back
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
