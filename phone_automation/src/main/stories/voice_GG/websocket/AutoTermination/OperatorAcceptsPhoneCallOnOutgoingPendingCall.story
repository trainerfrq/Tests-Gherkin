Narrative:
GIVEN an active call on an operator position
WHEN the operator position initiates a new call
THEN the active call shall be cleared

Meta:
     @BeforeStory: ../includes/@PrepareTwoClientsWithMissionsAndSipPhone.story
     @AfterStory: ../includes/@CleanupTwoClientsAndSipPhone.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target callTarget and names outgoingPhoneCallId
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_trying

Scenario: Callee client receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId1
And WS2 confirms incoming phone call with callId incomingPhoneCallId1
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Clear buffers
When WS1 clears all text messages from buffer named CallStatusIndicationBuffer1
When WS2 clears all text messages from buffer named CallStatusIndicationBuffer2

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>

Scenario: Define call source and target
When define values in story data:
| name         | value      |
| calledSource | sip:cats   |
| calledTarget | sip:111111 |

Scenario: Callee client receives the incoming call and confirms it
When WS1 receives call incoming indication on message buffer named CallIncomingIndicationBuffer1 with calledSource and calledTarget and names incomingPhoneCallId2
And WS1 confirms incoming phone call with callId incomingPhoneCallId2
Then SipContact DialogState is EARLY within 100 ms

Scenario: Callee client answers the incoming call
When WS1 answers the incoming phone call with the callId incomingPhoneCallId2
And waiting for 1 seconds
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId incomingPhoneCallId2 and status connected
Then SipContact DialogState is CONFIRMED within 100 ms

Scenario: Verify first call is terminated
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status terminated
Then WS2 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and terminationDetails normal

Scenario: Callee client clears the phone call
When WS1 clears the phone call with the callId incomingPhoneCallId2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS1 removes the message buffer named CallIncomingIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
