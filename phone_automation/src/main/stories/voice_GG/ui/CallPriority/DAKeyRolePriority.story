Narrative:
As a caller operator having set a DAKey with Call Priority: ROLE
I want to establish a phone call
So I can verify that call has caller's operator role priority

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key                  | source                         | target                         | callType |
| OP2-RoleEmergency    | <<OP2_URI>>                    | <<ROLE_EMERGENCY_URI>>         | DA/IDA   |
| RoleEmergency-OP2    | <<ROLE_EMERGENCY_URI>>         | <<OP2_URI>>                    | DA/IDA   |

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: Op2 changes grid tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 3

Scenario: Op2 checks DAKey priority
		  @REQUIREMENTS:GID-4698739
When HMI OP2 has the DA key RoleEmergency with call priority NORMAL

Scenario: Op2 establishes an outgoing call
When HMI OP2 presses DA key RoleEmergency
Then HMI OP2 has the DA key RoleEmergency in state out_ringing
Then HMI OP2 has the call queue item RoleEmergency-OP2 in state out_ringing

Scenario: Operators part of called role receive the incoming call
Then HMI OP1 has the call queue item OP2-RoleEmergency in state inc_initiated
Then HMI OP3 has the call queue item OP2-RoleEmergency in state inc_initiated

Scenario: Op2 checks call priority
When HMI OP2 has the call queue item RoleEmergency-OP2 with priority NORMAL

Scenario: Op1 checks call priority
When HMI OP1 has the call queue item OP2-RoleEmergency with priority NORMAL

Scenario: Op2 client clears the phone call
When HMI OP2 presses DA key RoleEmergency
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op2 changes grid tab back
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: Op2 changes its mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_4_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_4_NAME>>

Scenario: Op2 checks DAKey priority
		  @REQUIREMENTS:GID-4698739
When HMI OP2 has the DA key RoleEmergency(as Mission4) with call priority EMERGENCY

Scenario: Op2 establishes an outgoing call
When HMI OP2 presses DA key RoleEmergency(as Mission4)
Then HMI OP2 has the DA key RoleEmergency(as Mission4) in state out_ringing
Then HMI OP2 has the call queue item RoleEmergency-OP2 in state out_ringing

Scenario: Operators part of called role receive the incoming call
Then HMI OP1 has the call queue item OP2-RoleEmergency in state inc_initiated
Then HMI OP3 has the call queue item OP2-RoleEmergency in state inc_initiated

Scenario: Op2 checks call priority
When HMI OP2 has the call queue item RoleEmergency-OP2 with priority EMERGENCY

Scenario: Op1 checks call priority
When HMI OP1 has the call queue item OP2-RoleEmergency with priority EMERGENCY

Scenario: Op2 client clears the phone call
When HMI OP2 presses DA key RoleEmergency(as Mission4)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Clean-up: Op2 changes its mission back
When HMI OP2 with layout <<LAYOUT_MISSION4>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: Cleanup - always select first tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
