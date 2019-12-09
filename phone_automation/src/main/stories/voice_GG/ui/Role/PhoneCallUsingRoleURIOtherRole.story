Narrative:
As a caller operator
I want to initiate a phone call using an Role SIP URI towards a role other than mine
So I can verify that the phone call is initiated towards all the logged in operators of the target role

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key              | source                | target                      | callType |
| OP2-Role1        | <<OP2_URI>>           | sip:role1@example.com       | DA/IDA   |
| Role2-Role1      | sip:role2@example.com | sip:role1@example.com       | DA/IDA   |
| OP2-Role1Alias   | <<OP2_URI>>           | sip:role1alias1@example.com | DA/IDA   |
| Role2-Role1Alias | sip:role2@example.com | sip:role1alias1@example.com | DA/IDA   |

Scenario: Caller establishes an outgoing call towards Role1 as OP2
		  @REQUIREMENTS:GID-2886201
When HMI OP2 presses DA key ROLE1
Then HMI OP2 has the DA key ROLE1 in state out_ringing

Scenario: Operators part of called role receive the incoming call
		  @REQUIREMENTS:GID-3229739
Then HMI OP1 has the call queue item OP2-Role1 in state inc_initiated
Then HMI OP3 has the call queue item OP2-Role1 in state inc_initiated

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1

Scenario: Caller establishes an outgoing call towards Role1 as Role2
		  @REQUIREMENTS:GID-2886201
		  @REQUIREMENTS:GID-2952544
When HMI OP2 presses DA key ROLE1(as ROLE2)
Then HMI OP2 has the DA key ROLE1(as ROLE2) in state out_ringing

Scenario: Operators part of called role receive the incoming call
Then HMI OP1 has the call queue item Role2-Role1 in state inc_initiated
Then HMI OP3 has the call queue item Role2-Role1 in state inc_initiated

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1(as ROLE2)

Scenario: Caller establishes an outgoing call towards Role1-Alias as OP2
		  @REQUIREMENTS:GID-2886201
When HMI OP2 presses DA key ROLE1-ALIAS
Then HMI OP2 has the DA key ROLE1-ALIAS in state out_ringing

Scenario: Operators part of called role receive the incoming call
Then HMI OP1 has the call queue item OP2-Role1Alias in state inc_initiated
Then HMI OP3 has the call queue item OP2-Role1Alias in state inc_initiated

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1-ALIAS

Scenario: Caller establishes an outgoing call towards Role1-Alias as Role2
		  @REQUIREMENTS:GID-2886201
When HMI OP2 presses DA key ROLE1-ALIAS(as ROLE2)
Then HMI OP2 has the DA key ROLE1-ALIAS(as ROLE2) in state out_ringing

Scenario: Operators part of called role receive the incoming call
Then HMI OP1 has the call queue item Role2-Role1Alias in state inc_initiated
Then HMI OP3 has the call queue item Role2-Role1Alias in state inc_initiated

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1-ALIAS(as ROLE2)

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting for 1 millisecond
