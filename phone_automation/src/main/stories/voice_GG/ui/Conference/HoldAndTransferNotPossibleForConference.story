Narrative:
As an operator (initiator or participant) part of an active conference
I want to put on hold or transfer the conference call
So I can verify that the conference call can't be put on hold or be transferred

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key          | source                | target           | callType |
| OP1-OP2      | <<OP1_URI>>           | <<OP2_URI>>      | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>           | <<OP1_URI>>      | DA/IDA   |
| OP1-OP2-Conf | <<OP1_URI>>           | <<OP2_URI>>      | CONF     |
| OP2-OP1-Conf | <<OPVOICE2_CONF_URI>> | <<OP1_URI>>      | CONF     |
| OP2-OP3-Conf | <<OPVOICE2_CONF_URI>> | <<OP3_URI>>:5060 | CONF     |

Scenario: Op2 establishes an outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Op1 client receives the incoming call and answers the call
Then HMI OP1 has the DA key OP2 in state inc_initiated
When HMI OP1 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op2 starts a conference using an existing active call
When HMI OP2 starts a conference using an existing active call
And waiting for 1 second
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 2 participants
Then HMI OP2 has a notification that shows Conference call active

Scenario: Op1 call state verification
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected

Scenario: Op2 adds another participant to the conference
When HMI OP2 presses DA key OP3
And waiting for 1 second

Scenario: Op3 client receives the incoming call and answers the call
Then HMI OP3 has the call queue item OP2-OP3-Conf in state inc_initiated
Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: Op3 call state verification
Then HMI OP3 has the call queue item OP2-OP3-Conf in state connected
Then HMI OP3 has the call queue item OP2-OP3-Conf in the active list with name label CONF

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP1_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP2_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OP3_NAME>>

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: Op2 verifies that conference can't be put on hold or transfer
		  @REQUIREMENTS:GID-2529035
		  @REQUIREMENTS:GID-2529033
Then HMI OP2 verifies that hold button does not exists
Then HMI OP2 verifies that transfer button does not exists

Scenario: Op1 verifies that conference can't be put on hold or transfer
!-- TODO: Enable the test when story QXVP-14225 is done
Then HMI OP1 verifies that hold button does not exists
Then HMI OP1 verifies that transfer button does not exists

Scenario: Op3 verifies that conference can't be put on hold or transfer
Then HMI OP3 verifies that hold button does not exists
Then HMI OP3 verifies that transfer button does not exists

Scenario: Op2 leaves the conference
Then HMI OP2 terminates the call queue item OP1-OP2-Conf
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is not terminated also for the left participants
		  @REQUIREMENTS:GID-2529028
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 verifies that conference can't be put on hold or transfer
Then HMI OP1 verifies that hold button does not exists
Then HMI OP1 verifies that transfer button does not exists

Scenario: Op3 verifies that conference can't be put on hold or transfer
Then HMI OP3 verifies that hold button does not exists
Then HMI OP3 verifies that transfer button does not exists

Scenario: Op1 leaves the conference
Then HMI OP1 terminates the call queue item OP2-OP1-Conf
Then wait for 2 seconds

Scenario: Op1 and Op3 have 0 calls in call queue
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
