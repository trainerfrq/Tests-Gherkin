Narrative:
As an operator part of an active DA call
I want to start a conference
So I can add and/or remove participants to the call

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
| OP1-OP2-CONF | <<OP1_URI>>           | <<OP2_URI>>      | CONF     |
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
		  @REQUIREMENTS:GID-4021244
		  @REQUIREMENTS:GID-3371944
When HMI OP2 starts a conference using an existing active call
And waiting for 1 second
Then HMI OP2 has the call queue item OP1-OP2-CONF in state connected
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with info label 2 participants

Scenario: Verify conference call notification
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that list State contains text Conference call active

Scenario: Close popup window
Then HMI OP2 closes notification popup

Scenario: Op1 call state verification
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with name label CONF
!-- Then HMI OP1 verifies that the DA key OP2 has the info label Conference

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP1_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP2_NAME>>

Scenario: Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: Op2 adds another participant to the conference
		  @REQUIREMENTS:GID-2529024
When HMI OP2 presses DA key OP3
And waiting for 1 second

Scenario: Op3 client receives the incoming call and answers the call
Then HMI OP3 has the call queue item OP2-OP3-Conf in state inc_initiated
Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: Op2 verifies conference state
Then HMI OP2 has the call queue item OP1-OP2-CONF in state connected
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with info label 3 participants

Scenario: Verify conference call notification
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that list State contains text Conference call active

Scenario: Close popup window
Then HMI OP2 closes notification popup

Scenario: Op2 verifies conference participants list
		  @REQUIREMENTS:GID-3229804
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OP3_NAME>>
Then HMI OP2 verifies that remove conference participant button is disabled
Then HMI OP2 verifies that leave conference button is enabled

Scenario: Op3 call state verification
Then HMI OP3 has the call queue item OP2-OP3-Conf in state connected
Then HMI OP3 has the call queue item OP2-OP3-Conf in the active list with name label CONF
!-- Then HMI OP3 verifies that the DA key OP2 has the info label Conference

Scenario: On Op2 position DA buttons of the participants are correctly signalized
!-- TODO: change label to "Conference" after the bug is fixed
Then HMI OP2 verifies that the DA key OP1 has the info label Add to Conf
Then HMI OP2 verifies that the DA key OP3 has the info label Add to Conf

Scenario: Op2 removes one participant from conference participants list
When HMI OP2 selects conference participant: 0
Then HMI OP2 verifies that remove conference participant button is enabled
Then HMI OP2 removes conference participant
And waiting for 1 second
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP3_NAME>>

Scenario: Call is terminated for the removed participant
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op2 verifies conference state
Then HMI OP2 has the DA key OP1 in state terminated
!-- TODO: change label to "Conference" after the bug is fixed
Then HMI OP2 verifies that the DA key OP3 has the info label Add to Conf
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with info label 2 participants

Scenario: Op2 leaves the conference
		  @REQUIREMENTS:GID-2529028
Then HMI OP2 leaves conference
And waiting for 1 second
Then HMI OP2 has the DA key OP3 in state terminated
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for the left participant
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
