Narrative:
As a caller operator
I want to establish and clear a phone call to a SIP phone
So I can verify all call states on both sides

Meta:
     @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
     @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>

Scenario: Define call source and target
When define values in story data:
| name         | value      |
| calledSource | sip:cats   |
| calledTarget | sip:111111 |

Scenario: Callee client receives the incoming call and confirms it
When WS1 receives call incoming indication on message buffer named CallIncomingIndicationBuffer1 with calledSource and calledTarget and names incomingPhoneCallId
And WS1 confirms incoming phone call with callId incomingPhoneCallId
Then SipContact DialogState is EARLY within 100 ms

Scenario: Callee client answers the incoming call
When WS1 answers the incoming phone call with the callId incomingPhoneCallId
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId incomingPhoneCallId and status connected
Then SipContact DialogState is CONFIRMED within 100 ms

Scenario: Sip phone terminates the phone call
		  @REQUIREMENTS:GID-2510109
When SipContact terminates calls
And waiting for 3 seconds
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId incomingPhoneCallId and terminationDetails normal

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallIncomingIndicationBuffer1
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1