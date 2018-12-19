Narrative:
As a caller operator
I want to establish a call towards a target that has a matching phone book entry
So that I can verify that the call establish indication contains the contact related information

Meta: @BeforeStory: ../includes/@PrepareTwoClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupTwoClients.story

Scenario: Define phone book entries
Given the following phone book entries:
| key         | uri                    | name         | full-name             | location | organization    | notes                                                          | display-addon |
| targetEntry | sip:222222@example.com | OP2 Physical | Physical Identity OP2 | XVP Lab  | FRQ XVP GG-Team | This is the physical identity of the second operating position |               |

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2

Scenario: Define call source and target
When define values in story data:
| name         | value                  |
| callSource   | <<OPVOICE1_PHONE_URI>> |
| calledTarget | sip:222222@example.com |

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target calledTarget and names outgoingPhoneCallId
And waiting for 3 seconds

Scenario: Caller client receives call status indication with calledParty matching phone book entry
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with calledParty matching phone book entry targetEntry

Scenario: Callee client receives call incoming indication with calledParty matching phone book entry
		  @REQUIREMENTS:GID-2877902
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with calledParty matching phone book entry targetEntry

Scenario: Caller client clears the phone call
When WS1 clears the phone call with the callId incomingPhoneCallId

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
