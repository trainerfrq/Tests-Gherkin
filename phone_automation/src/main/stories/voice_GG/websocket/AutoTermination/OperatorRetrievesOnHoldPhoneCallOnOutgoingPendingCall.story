Narrative:
As an operator having an outgoing pending phone call and a phone call on hold
I want to retrieve the phone call on hold
So that I can verify that the outgoing pending phone call is terminated

Meta:
     @BeforeStory: ../includes/@PrepareTwoClientsWithMissionsAndSipPhone.story
     @AfterStory: ../includes/@CleanupTwoClientsAndSipPhone.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS1 queries phone data for mission missionId1 in order to call OP2 and names them callSource and callTarget

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
And waiting for 1 seconds
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status connected
And WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status connected

Scenario: Caller client puts the call on hold
When WS1 puts the phone call with the callId outgoingPhoneCallId1 on hold
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status hold
And WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status held

Scenario: Clear buffers
When WS1 clears all text messages from buffer named CallStatusIndicationBuffer1
When WS2 clears all text messages from buffer named CallStatusIndicationBuffer2

Scenario: Define call target
When define values in story data:
| name         | value          |
| calledTarget | <<SIP_PHONE1>> |

Scenario: Callee establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target calledTarget and names outgoingPhoneCallId2
Then SipContact DialogState is EARLY within 100 ms
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status out_ringing

Scenario: Callee client retrieves call on hold
		  @REQUIREMENTS:GID-2878006
When WS1 retrieves the on hold phone call with the callId outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status connected

Scenario: Verify outgoing pending call was terminated
When waiting for 1 seconds
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status terminated
Then SipContact DialogState is TERMINATED within 100 ms

Scenario: Callee client clears the phone call
When WS1 clears the phone call with the callId outgoingPhoneCallId1

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS1 removes the message buffer named CallIncomingIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
