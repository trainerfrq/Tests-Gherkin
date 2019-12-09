Narrative:
As an operator
I want to initiate an outgoing IA call towards a role
So that I can verify that the IA call is automatically accepted by one of the logged in operators
part of the target role and declined by all the other operators

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                   | target                   | callType |
| OP2-ROLE1 | <<OP2_URI>>              | sip:role1@example.com | IA       |
| ROLE1-OP1 | sip:role1@example.com | <<OP2_URI>>              | IA       |

Scenario: Caller establishes an outgoing IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - ROLE1
Then HMI OP2 has the call queue item ROLE1-OP1 in state connected
Then HMI OP2 has the IA key IA - ROLE1 in state connected
And waiting for 2 seconds

Scenario: IA call is auto-accepted for one operator and declined for the others
		  @REQUIREMENTS:GID-2686133
Then the call queue item OP2-ROLE1 is connected for only one of the operator positions: HMI OP1, HMI OP3

Scenario: Cleanup IA call
When HMI OP2 presses IA key IA - ROLE1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
