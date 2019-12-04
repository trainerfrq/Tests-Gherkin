Narrative:
As a caller operator
I want to initiate a phone call using an Role SIP URI towards a role other than mine
So I can verify that the caller identity for the incoming call is displayed.

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key              | source                   | target                         | callType |
| OP2-Role1        | <<OP2_URI>>              | sip:role1@example.com       | DA/IDA   |
| Role2-Role1      | sip:role2@example.com | sip:role1@example.com       | DA/IDA   |
| OP2-Role1Alias   | <<OP2_URI>>              | sip:role1alias1@example.com | DA/IDA   |
| Role2-Role1Alias | sip:role2@example.com | sip:role1alias1@example.com | DA/IDA   |

Scenario: Caller establishes an outgoing call towards Role1 as OP2
When HMI OP2 presses DA key ROLE1

Scenario: Operators part of called role receive the incoming call with caller identity
		  @REQUIREMENTS:GID-3547601
Then HMI OP1 has the call queue item OP2-Role1 in the waiting list with name label <<OP2_NAME>>
Then HMI OP3 has the call queue item OP2-Role1 in the waiting list with name label <<OP2_NAME>>

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1

Scenario: Caller establishes an outgoing call towards Role1 as Role2
When HMI OP2 presses DA key ROLE1(as ROLE2)

Scenario: Operators part of called role receive the incoming call with caller identity
Then HMI OP1 has the call queue item Role2-Role1 in the waiting list with name label role2
Then HMI OP3 has the call queue item Role2-Role1 in the waiting list with name label role2

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1(as ROLE2)

Scenario: Caller establishes an outgoing call towards Role1-Alias as OP2
When HMI OP2 presses DA key ROLE1-ALIAS

Scenario: Operators part of called role receive the incoming call with caller identity
Then HMI OP1 has the call queue item OP2-Role1Alias in the waiting list with name label <<OP2_NAME>>
Then HMI OP3 has the call queue item OP2-Role1Alias in the waiting list with name label <<OP2_NAME>>

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1-ALIAS

Scenario: Caller establishes an outgoing call towards Role1-Alias as Role2
When HMI OP2 presses DA key ROLE1-ALIAS(as ROLE2)

Scenario: Operators part of called role receive the incoming call with caller identity
Then HMI OP1 has the call queue item Role2-Role1Alias in the waiting list with name label role2
Then HMI OP3 has the call queue item Role2-Role1Alias in the waiting list with name label role2

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1-ALIAS(as ROLE2)
Then wait for 2 seconds

Scenario: Call is terminated for all three operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
