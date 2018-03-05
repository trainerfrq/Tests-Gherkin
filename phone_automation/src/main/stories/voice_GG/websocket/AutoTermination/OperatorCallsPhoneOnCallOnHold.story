Narrative:
As an operator having a phone call on hold
I want to establish another phone call
So that I can verify that the first phone call is NOT terminated

Meta:
     @BeforeStory: ../includes/@PrepareTwoClientsWithMissionsAndSipPhone.story
     @AfterStory: ../includes/@CleanupTwoClientsAndSipPhone.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target callTarget and names outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_trying

Scenario: Callee client receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId1
And WS2 confirms incoming phone call with callId incomingPhoneCallId1
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_ringing

Scenario: Callee client answers the incoming call
When WS2 answers the incoming phone call with the callId incomingPhoneCallId1
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status connected
And WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status connected

Scenario: Caller client puts the call on hold
When WS1 puts the phone call with the callId outgoingPhoneCallId1 on hold
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status hold
And WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status held

Scenario: Define call target
When define values in story data:
| name           | value          |
| sipPhoneTarget | <<SIP_PHONE1>> |

Scenario: Clear buffers
When WS1 clears all text messages from buffer named CallStatusIndicationBuffer1
When WS2 clears all text messages from buffer named CallStatusIndicationBuffer2

Scenario: Caller establishes another outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target sipPhoneTarget and names outgoingPhoneCallId2
And waiting for 1 seconds
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status out_ringing

Scenario: Verify first call is NOT terminated
Then WS1 does NOT receive call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status terminated

Scenario: Caller client clears the phone call
When WS1 clears the phone call with the callId outgoingPhoneCallId1
When WS1 clears the phone call with the callId outgoingPhoneCallId2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
