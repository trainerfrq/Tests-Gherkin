Narrative:
As a callee operator having an incoming call from a SIP contact
I want to have a matching entry for the caller SIP contact
So that I can verify that the telephone book entry display name will be displayed on the call queue item

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key      | profile | user-entity | sip-uri                 |
| Caller1  | VOIP    | 1           | sip:1@10.31.205.9:5070  |
| Caller2  | VOIP    | 2           | sip:2@10.31.205.9:5070  |
| Caller3  | VOIP    | 3           | sip:3@10.31.205.9:5070  |
| Caller4  | VOIP    | 4           | sip:4@10.31.205.9:5070  |
| Caller5  | VOIP    | 5           | sip:5@10.31.205.9:5070  |
| Caller6  | VOIP    | 6           | sip:6@10.31.205.9:5070  |
| Caller7  | VOIP    | 7           | sip:7@10.31.205.9:5070  |
| Caller8  | VOIP    | 8           | sip:8@10.31.205.9:5070  |
| Caller9  | VOIP    | 9           | sip:9@10.31.205.9:5070  |
| Caller10 | VOIP    | 10          | sip:10@10.31.205.9:5070 |
| Caller11 | VOIP    | 11          | sip:11@10.31.205.9:5070 |
| Caller12 | VOIP    | 12          | sip:12@10.31.205.9:5070 |
| Caller13 | VOIP    | 13          | sip:13@10.31.205.9:5070 |
| Caller14 | VOIP    | 14          | sip:14@10.31.205.9:5070 |
| Caller15 | VOIP    | 15          | sip:15@10.31.205.9:5070 |
| Caller16 | VOIP    | 16          | sip:11@10.31.205.9:5070 |

Given phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key         | source                 | target                 | callType |
| Caller1-OP1 | sip:1@10.31.205.9:5070 | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| OP1-OP2     | <<OP1_URI>>            | <<OP2_URI>>            | IA       |
| OP2-OP1     | <<OP2_URI>>            | <<OP1_URI>>            | IA       |

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: Op2 tries to establishes an outgoing IA call to Op1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1

Scenario: Op2 has a failed call in the call queue
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the IA key IA - OP2 in state terminated

Scenario: Op2 terminates failed call
When HMI OP2 presses IA key IA - OP1

Scenario: Op1 answers one call
Then HMI OP1 accepts the call queue item Caller1-OP1

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: Op1 terminates active call
Then HMI OP1 terminates the call queue item Caller1-OP1

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: Op2 tries to establishes an outgoing IA call to Op1
When HMI OP2 presses IA key IA - OP1
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: Op2 terminates call
When HMI OP2 presses IA key IA - OP1

Scenario: Sip phones are cleared
When SipContact terminates calls

Scenario: Remove phone
When SipContact is removed

Scenario: Cleanup - always select first tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond

