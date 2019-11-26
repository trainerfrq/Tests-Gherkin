Narrative:
As an operator having an active conference
I want to add a new participant which is in a call forward loop to the conference
So I can be informed of the call forward loop and continue the conference

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key          | source                | target      | callType |
| OP3-OP2      | <<OP3_URI>>           | <<OP2_URI>> | DA/IDA   |
| OP2-OP3      | <<OP2_URI>>           | <<OP3_URI>> | DA/IDA   |
| OP3-OP2-Conf | <<OP3_URI>>           | <<OP2_URI>> | CONF     |
| OP2-OP3-Conf | <<OPVOICE2_CONF_URI>> | <<OP3_URI>> | CONF     |

Scenario: Op1 activates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
When HMI OP1 presses DA key OP3
Then HMI OP1 verifies that call queue info container contains Target: <<OP3_NAME>>
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op2 establishes an outgoing call
When HMI OP2 presses DA key OP3
Then HMI OP2 has the DA key OP3 in state out_ringing

Scenario: Op3 client receives the incoming call and answers the call
Then HMI OP3 has the DA key OP2 in state inc_initiated
When HMI OP3 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Op2 starts a conference using an existing active call
		  @REQUIREMENTS:GID-4021244
When HMI OP2 starts a conference using an existing active call
Then HMI OP2 has the call queue item OP3-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP3-OP2-Conf in the active list with name label CONF
Then HMI OP2 has the call queue item OP3-OP2-Conf in the active list with info label 2 participants

Scenario: Verify conference call notification
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that list State contains text Conference call active

Scenario: Close popup window
Then HMI OP2 closes notification popup

Scenario: Op3 call state verification
Then HMI OP3 has the call queue item OP2-OP3-Conf in state connected

Scenario: Op2 verifies conference participants list
		  @REQUIREMENTS:GID-3229804
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP3_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP2_NAME>>

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: Op2 wants to add Op1 as conference participant
When HMI OP2 presses DA key OP1

Scenario: Call will be forwarded to Op3
!-- TODO: Enable test when bug QXVP-14167 is fixed
Then HMI OP3 has the call queue item OP2-OP3-Conf in the waiting list with name label CONF

Scenario: Verify that conference is still on going for Op3
Then HMI OP3 has the call queue item OP2-OP3-Conf in the active list with name label CONF

Scenario: Verify that Op1 hasn't any calls in the call queue
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op3 answers the call
Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: Op2 verifies conference participants list
		  @REQUIREMENTS:GID-3657854
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP2_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status ringing
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP1_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OP3_NAME>>

Scenario: Op2 leaves the conference
Then HMI OP2 leaves conference
Then HMI OP2 has the DA key OP3 in state terminated
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for the left participant
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Verify that Op1 hasn't any calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond




