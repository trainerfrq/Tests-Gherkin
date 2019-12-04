Narrative:
As a conference participant in an active conference
I want to receive a DA call
So I can verify that if I answer the DA call I will automatically leave the conference

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key            | source                | target                 | callType |
| OP1-OP2        | <<OP1_URI>>           | <<OP2_URI>>            | DA/IDA   |
| OP2-OP1        | <<OP2_URI>>           | <<OP1_URI>>            | DA/IDA   |
| OP1-OP2-Conf   | <<OP1_URI>>           | <<OP2_URI>>            | CONF     |
| OP2-OP1-Conf   | <<OPVOICE2_CONF_URI>> | <<OP1_URI>>            | CONF     |
| OP2-OP3-Conf   | <<OPVOICE2_CONF_URI>> | <<OP3_URI>>:5060       | CONF     |
| SipContact-OP1 | <<SIP_PHONE2>>        | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

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
Then wait for 2 seconds

Scenario: Op3 client receives the incoming call and answers the call
Then HMI OP3 has the call queue item OP2-OP3-Conf in state inc_initiated
Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP1_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP2_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OP3_NAME>>

Scenario: Sip phone calls Op1
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Op1 receives the incoming call
Then HMI OP1 has the call queue item SipContact-OP1 in state inc_initiated
Then HMI OP1 has the call queue item SipContact-OP1 in the waiting list with name label Madoline
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has in the call queue a number of 2 calls

Scenario: Op1 accepts call
		  @REQUIREMENTS:GID-2878006
Then HMI OP1 accepts the call queue item SipContact-OP1
And waiting for 1 second
Then HMI OP1 has the call queue item SipContact-OP1 in state connected
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Op2 verifies conference participants list
		  @REQUIREMENTS:GID-3229804
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP2_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP3_NAME>>

Scenario: Op2 leaves the conference
Then HMI OP2 leaves conference
And waiting for 1 second
Then HMI OP2 has the DA key OP3 in state terminated
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for the left participant
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Sip phone clears calls
When SipContact terminates calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond

