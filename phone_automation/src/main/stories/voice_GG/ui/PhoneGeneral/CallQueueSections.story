Narrative:
As an operator
I want to establish and receive different types of call
So I can verify that calls are shown in the correct call sections and the operations specific to the sections are permitted

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key            | source                 | target                 | callType |
| OP1-OP2        | <<OP1_URI>>    | <<OP2_URI>>            | DA/IDA   |
| OP2-OP1        | <<OP2_URI>>    | <<OP1_URI>>            | DA/IDA   |
| OP3-OP1        | <<OP3_URI>>    | <<OP1_URI>>            | DA/IDA   |
| OP1-OP3        | <<OP1_URI>>    | <<OP3_URI>>            | DA/IDA   |
| IA-OP1-OP2     | <<OP1_URI>>    | <<OP2_URI>>            | IA       |
| IA-OP2-OP1     | <<OP2_URI>>    | <<OP1_URI>>            | IA       |
| SipContact-OP1 | <<SIP_PHONE2>>         | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

Scenario: Op3 initiates a priority call
When HMI OP3 initiates a priority call on DA key OP1
Then HMI OP3 has the call queue item OP1-OP3 in the active list with name label <<OP1_NAME>>

Scenario: Op1 receives a priority call and verifies call queue section (priority)
		  @REQUIREMENTS:GID-3371933
		  @REQUIREMENTS:GID-3371931
		  @REQUIREMENTS:GID-3371943
		  @REQUIREMENTS:GID-3490383
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>
Then HMI OP1 verifies that the call queue item OP3-OP1 from the priority list has call type DA

Scenario: Op2 initiates an IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has the call queue item IA-OP1-OP2 in the active list with name label <<OP1_NAME>>

Scenario: Op1 receives an IA call and verifies call queue section (active)
Then HMI OP1 has the call queue item IA-OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>
Then HMI OP1 verifies that the call queue item IA-OP2-OP1 from the active list has call type IA

Scenario: Op2 terminates IA call
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op2 initiates a priority call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP2 initiates a priority call on DA key OP1
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>

Scenario: Op1 receives another priority call and verifies call queue section (priority)
Then HMI OP1 has in the call queue the item OP2-OP1 with priority
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with name label <<OP2_NAME>>
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>
Then HMI OP1 verifies that the call queue item OP2-OP1 from the priority list has call type DA

Scenario: Op1 answers the last incoming priority call
When HMI OP1 presses DA key OP2
Then HMI OP1 verifies that the call queue item OP2-OP1 was removed from the priority list
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>

Scenario: Op2 has an active call
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>

Scenario: Op3 terminates the call
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Op3 initiates a DA call
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing
Then HMI OP3 has the call queue item OP1-OP3 in the active list with name label <<OP1_NAME>>

Scenario: Op1 receives a DA call and verifies call queue section (waiting)
Then HMI OP1 has the DA key OP3 in state inc_initiated
Then HMI OP1 has the call queue item OP3-OP1 in the waiting list with name label <<OP3_NAME>>
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP1 verifies that the call queue item OP3-OP1 from the waiting list has call type DA

Scenario: Op1 receives a SIP call
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds
Then HMI OP1 has the call queue item SipContact-OP1 in the waiting list with name label Madoline
Then HMI OP1 has the call queue item OP3-OP1 in the waiting list with name label <<OP3_NAME>>
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>

Scenario: Op1 puts the active call on hold and verifies call queue section (hold)
When HMI OP1 puts on hold the active call
Then HMI OP1 verifies that the call queue item OP2-OP1 was removed from the active list
Then HMI OP1 has the call queue item OP2-OP1 in the hold list with name label <<OP2_NAME>>
Then HMI OP1 has the call queue item SipContact-OP1 in the waiting list with name label Madoline
Then HMI OP1 has the call queue item OP3-OP1 in the waiting list with name label <<OP3_NAME>>
Then HMI OP1 verifies that the call queue item OP2-OP1 from the hold list has call type DA

Scenario: Op1 answers Sip call
Then HMI OP1 accepts the call queue item SipContact-OP1
Then HMI OP1 has the call queue item SipContact-OP1 in the active list with name label Madoline

Scenario: Op1 puts the Sip call on hold and verifies call queue section (hold)
When HMI OP1 puts on hold the active call
Then HMI OP1 verifies that the call queue item SipContact-OP1 was removed from the active list
Then HMI OP1 has the call queue item SipContact-OP1 in the hold list with name label Madoline
Then HMI OP1 has the call queue item OP3-OP1 in the waiting list with name label <<OP3_NAME>>
Then HMI OP1 has the call queue item OP2-OP1 in the hold list with name label <<OP2_NAME>>
Then HMI OP1 verifies that the call queue item SipContact-OP1 from the hold list has call type DA

Scenario: Op1 answers the DA call and verifies call queue section (active)
Then HMI OP1 accepts the call queue item OP3-OP1
Then HMI OP1 verifies that the call queue item OP3-OP1 was removed from the waiting list
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>

Scenario: Operator initiates transfer for the active call
When HMI OP1 initiates a transfer on the active call
Then HMI OP1 verifies that the call queue item OP3-OP1 was removed from the active list

Scenario: Operator verifies the items from the hold section
		  @REQUIREMENTS:GID-3371934
Then HMI OP1 has the call queue item OP3-OP1 in the hold list with name label <<OP3_NAME>>
Then HMI OP1 has the call queue item SipContact-OP1 in the hold list with name label Madoline
Then HMI OP1 has the call queue item OP2-OP1 in the hold list with name label <<OP2_NAME>>

Scenario: Operator retrieves and terminates all calls
		  @REQUIREMENTS:GID-3371935
Then HMI OP1 retrieves from hold the call queue item OP2-OP1
Then HMI OP1 verifies that the call queue item OP2-OP1 was removed from the hold list
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP1 terminates the call queue item OP2-OP1
Then HMI OP1 retrieves from hold the call queue item OP3-OP1
Then HMI OP1 verifies that the call queue item OP3-OP1 was removed from the hold list
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>
Then HMI OP1 terminates the call queue item OP3-OP1

Scenario: Operator retrieves the SIP Call
Then HMI OP1 retrieves from hold the call queue item SipContact-OP1

Scenario: Operator terminates the SIP Call
When SipContact terminates calls

Scenario: Verify call is terminated for all operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

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
