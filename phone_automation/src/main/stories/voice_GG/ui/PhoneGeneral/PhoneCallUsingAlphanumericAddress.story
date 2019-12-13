Narrative:
As a caller operator
I want to initiate a phone call using an Alphanumeric Address Format SIP URI
So I can verify that the phone call is initiated towards the called operator

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Caller establishes an outgoing call
		  @REQUIREMENTS:GID-2541686
		  @REQUIREMENTS:GID-2682479
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP3 has the DA key OP1 in state inc_initiated

Scenario: Caller clears outgoing call
When HMI OP1 presses DA key OP3

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
