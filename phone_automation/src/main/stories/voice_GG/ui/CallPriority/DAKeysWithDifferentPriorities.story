Narrative:
As a caller operator having set a DAKey with requested Call Priority
I want to establish a phone call
So I can verify that the call has the desired priority for both operators

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
| OP3-OP1_urgent  | <<OP3_URI>>           | <<OP1_URI>>                 | DA/IDA   |
| OP1_urgent-OP3  | <<OP1_URI>>           | <<OP3_URI>>                 | DA/IDA   |
| OP1_Master-OP2   | <<ROLE1_URI>>         | <<OP2_URI>>                 | DA/IDA   |
| OP2-OP1_Master   | <<OP2_URI>>           |                             | DA/IDA   |

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

Scenario: Op3 client checks call priority
When HMI OP3 has the call queue item Role1-OP3 with priority EMERGENCY

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key ROLE1
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

Scenario: Op1 checks call priority
When HMI OP1 has the call queue item OP2-OP1 with priority NON-URGENT

Scenario: Op1 clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op1
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 checks DAKey priority
	 @REQUIREMENTS:GID-4698739
When HMI OP1 has the DA key OP2(as ActiveMission) with call priority NORMAL

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2(as ActiveMission)
Then HMI OP1 has the DA key OP2(as ActiveMission) in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1_Master in state out_ringing

Scenario: Op2 receives the incoming call
Then HMI OP2 has the call queue item OP1_Master-OP2 in state inc_initiated

Scenario: Op2 checks call priority
When HMI OP2 has the call queue item OP1_Master-OP2 with priority NORMAL

Scenario: Op1 checks call priority
When HMI OP1 has the call queue item OP2-OP1_Master with priority NORMAL

Scenario: Op1 clears the phone call
When HMI OP1 presses DA key OP2(as ActiveMission)
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op1
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op3 checks DAKey priority
		  @REQUIREMENTS:GID-4698739
When HMI OP3 has the DA key OP1-urgent with call priority URGENT

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP1-urgent
Then HMI OP3 has the DA key OP1-urgent in state out_ringing
Then HMI OP3 has the call queue item OP1_urgent-OP3 in state out_ringing

Scenario: Op1 client receives the incoming call
Then HMI OP1 has the call queue item OP3-OP1_urgent in state inc_initiated

Scenario: Op1 client checks call priority
When HMI OP1 has the call queue item OP3-OP1_urgent with priority URGENT

Scenario: Op3 client checks call priority
When HMI OP3 has the call queue item OP1_urgent-OP3 with priority URGENT

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key OP1-urgent
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting for 1 millisecond
