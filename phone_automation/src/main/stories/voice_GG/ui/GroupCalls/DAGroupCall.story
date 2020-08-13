Narrative:
As an operator being part of the target role of a DA call
I want to accept the DA call
So I can verify that the phone call is accepted on my operator position and the alerting is terminated for the other operators
part of the same role

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key                 | source                          | target                          | callType |
| OP2-Role1_groupCall | <<OP2_URI>>                     | sip:Role1-GroupCall@example.com | DA/IDA   |
| Role1_groupCall-OP2 | sip:Role1-GroupCall@example.com | <<OP2_URI>>                     | DA/IDA   |

Scenario: Caller establishes an outgoing call towards Role1 as OP2
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 3
When HMI OP2 presses DA key ROLE1-GROUPCALL
Then HMI OP2 has the DA key ROLE1-GROUPCALL in state out_ringing
Then HMI OP2 has the call queue item Role1_groupCall-OP2 in state out_ringing

Scenario: Operators part of called role receive the incoming call
		  @REQUIREMENTS: GID-2531620
Then HMI OP1 has the call queue item OP2-Role1_groupCall in state inc_initiated
Then HMI OP3 has the call queue item OP2-Role1_groupCall in state inc_initiated

Scenario: Op1 accepts incoming call
Then HMI OP1 accepts the call queue item OP2-Role1_groupCall
Then HMI OP1 has the call queue item OP2-Role1_groupCall in state connected

Scenario: Caller operator has the call in connected state
		  @REQUIREMENTS: GID-2531621
Then HMI OP2 has the call queue item Role1_groupCall-OP2 in state connected

Scenario: Op3 has no incoming call
		  @REQUIREMENTS: GID-2604501
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1-GROUPCALL

Scenario: Call is terminated on both positions
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup - select first tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
