Narrative:
As a conference participant in an active conference
I want to change mission
So I can verify that the conference is not affected by this action

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
| OP2-OP1-1    | conf                  | conf             | CONF     |
| OP2-OP3-Conf | <<OPVOICE2_CONF_URI>> | <<OP3_URI>>:5060 | CONF     |
Scenario: Op2 establishes an outgoing call
Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Op2 client receives the incoming call and answers the call
Then HMI OP2 has the DA key OP1 in state inc_initiated
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op2 starts a conference using an existing active call
When HMI OP2 starts a conference using an existing active call
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 2 participants

Scenario: Verify conference call notification
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that list State contains text Conference call active

Scenario: Close popup window
Then HMI OP2 closes notification popup

Scenario: Op1 call state verification
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with name label CONF

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
		  @REQUIREMENTS:GID-3229804
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP1_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP2_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OP3_NAME>>
Then HMI OP2 verifies that remove conference participant button is disabled
Then HMI OP2 verifies that leave conference button is enabled

Scenario: Op1 verifies conference participants list
When HMI OP1 opens the conference participants list
Then HMI OP1 verifies that conference participants list contains 3 participants
Then HMI OP1 verifies in the list that conference participant on position 1 has status connected
Then HMI OP1 verifies in the list that conference participant on position 1 has name <<OP2_NAME>>
Then HMI OP1 verifies in the list that conference participant on position 2 has status connected
Then HMI OP1 verifies in the list that conference participant on position 2 has name <<OP1_NAME>>
Then HMI OP1 verifies in the list that conference participant on position 3 has status connected
Then HMI OP1 verifies in the list that conference participant on position 3 has name <<OP3_NAME>>
Then HMI OP1 verifies that remove conference participant button is disabled
Then HMI OP1 verifies that leave conference button is enabled

Scenario: Op1 closes conference participants list
Then HMI OP1 closes Conference list popup window

Scenario: Op1 changes mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify conference participants status
		  @REQUIREMENTS: GID-3005111
Then HMI OP1 has the call queue item OP2-OP1-1 in state connected
Then HMI OP1 has the call queue item OP2-OP1-1 in the active list with name label CONF
Then HMI OP3 has the call queue item OP2-OP3-Conf in state connected
Then HMI OP3 has the call queue item OP2-OP3-Conf in the active list with name label CONF

Scenario: Op2 verifies conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP1_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP2_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OP3_NAME>>
Then HMI OP2 verifies that remove conference participant button is disabled
Then HMI OP2 verifies that leave conference button is enabled

Scenario: Op1 verifies conference participants list
When HMI OP1 opens the conference participants list
Then HMI OP1 verifies that conference participants list contains 3 participants
Then HMI OP1 verifies in the list that conference participant on position 1 has status connected
Then HMI OP1 verifies in the list that conference participant on position 1 has name <<OP2_NAME>>
Then HMI OP1 verifies in the list that conference participant on position 2 has status connected
Then HMI OP1 verifies in the list that conference participant on position 2 has name <<OP1_NAME>>
Then HMI OP1 verifies in the list that conference participant on position 3 has status connected
Then HMI OP1 verifies in the list that conference participant on position 3 has name <<OP3_NAME>>
Then HMI OP1 verifies that remove conference participant button is disabled
Then HMI OP1 verifies that leave conference button is enabled

Scenario: Op3 leaves the conference
Then HMI OP3 terminates the call queue item OP2-OP3-Conf
And waiting for 1 second

Scenario: Op1 verifies conference participants list
Then HMI OP1 verifies that conference participants list contains 2 participants
Then HMI OP1 verifies in the list that conference participant on position 1 has status connected
Then HMI OP1 verifies in the list that conference participant on position 1 has name <<OP2_NAME>>
Then HMI OP1 verifies in the list that conference participant on position 2 has status connected
Then HMI OP1 verifies in the list that conference participant on position 2 has name <<OP1_NAME>>

Scenario: Op1 closes conference participants list
Then HMI OP1 closes Conference list popup window

Scenario: Op1 changes mission
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify conference participants status
Then HMI OP1 has the call queue item OP2-OP1-1 in state connected
Then HMI OP1 has the call queue item OP2-OP1-1 in the active list with name label CONF

Scenario: Op2 verifies conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP1_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP2_NAME>>

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: Op1 verifies conference participants list
When HMI OP1 opens the conference participants list
Then HMI OP1 verifies that conference participants list contains 2 participants
Then HMI OP1 verifies in the list that conference participant on position 1 has status connected
Then HMI OP1 verifies in the list that conference participant on position 1 has name <<OP2_NAME>>
Then HMI OP1 verifies in the list that conference participant on position 2 has status connected
Then HMI OP1 verifies in the list that conference participant on position 2 has name <<OP1_NAME>>

Scenario: Op1 closes conference participants list
Then HMI OP1 closes Conference list popup window

Scenario: Op1 leaves the conference
Then HMI OP1 terminates the call queue item OP2-OP1-1

Scenario: Calls are terminated for all participants
Then waiting for 1 seconds
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done


