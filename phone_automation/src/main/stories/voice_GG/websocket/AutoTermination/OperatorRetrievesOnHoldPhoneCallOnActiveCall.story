Narrative:
As an operator having an active phone call and a phone call on hold
I want to retrieve the phone call on hold
So that I can verify that the active phone call is terminated

Meta:
     @BeforeStory: ../includes/@PrepareTwoClientsWithMissionsAndSipPhone.story
     @AfterStory: ../includes/@CleanupTwoClientsAndSipPhone.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget from the entry number 1

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target callTarget and names outgoingPhoneCallId
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_trying

Scenario: Callee client receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId1
And WS2 confirms incoming phone call with callId incomingPhoneCallId1
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Callee client answers the incoming call
When WS2 answers the incoming phone call with the callId incomingPhoneCallId1
And waiting for 1 seconds
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status connected
And WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status connected

Scenario: Caller client puts the call on hold
When WS1 puts the phone call with the callId outgoingPhoneCallId on hold
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status hold
And WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status held

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

Scenario: Callee client retrieves call on hold
When WS1 retrieves the on hold phone call with the callId outgoingPhoneCallId
And waiting for 1 seconds
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status connected
Then WS2 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status connected

Scenario: Verify active call was terminated
When waiting for 1 seconds
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId incomingPhoneCallId2 and status terminated
Then SipContact DialogState is TERMINATED within 100 ms

Scenario: Callee client clears the phone call
When WS1 clears the phone call with the callId outgoingPhoneCallId

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS1 removes the message buffer named CallIncomingIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
