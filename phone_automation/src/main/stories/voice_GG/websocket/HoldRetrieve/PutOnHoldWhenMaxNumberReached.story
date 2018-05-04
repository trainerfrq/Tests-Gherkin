Narrative:
As an operator having a call on hold with another operator and having the maximum number of calls on hold set to 1
I want to put another call on hold
So I can verify that the call is not put on hold and the other call remains unchanged

Meta:
     @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
     @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2
When WS3 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer3

Scenario: First client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource1 and callTarget1 from the entry number 1
When WS3 loads phone data for role roleId3 and names callSource2 and callTarget2 from the entry number 2

Scenario: First client establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource1 ang target callTarget1 and names outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_trying

Scenario: Second client receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource1 and callTarget1 and names incomingPhoneCallId1
And WS2 confirms incoming phone call with callId incomingPhoneCallId1
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_ringing

Scenario: Second client answers the incoming call
When WS2 answers the incoming phone call with the callId incomingPhoneCallId1
And waiting for 1 seconds
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status connected
And WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status connected

Scenario: Second client puts the call on hold
When WS2 puts the phone call with the callId incomingPhoneCallId1 on hold
And waiting for 2 seconds

Scenario: Verify call is on hold
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status held
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status hold

Scenario: Third client establishes an outgoing call
When WS3 establishes an outgoing phone call using source callSource2 ang target callTarget2 and names outgoingPhoneCallId2
And waiting for 1 seconds
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId2 and status out_trying

Scenario: Second client receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource2 and callTarget2 and names incomingPhoneCallId2
And WS2 confirms incoming phone call with callId incomingPhoneCallId2
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId2 and status out_ringing

Scenario: Second client answers the incoming call
When WS2 answers the incoming phone call with the callId incomingPhoneCallId2
And waiting for 1 seconds
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId2 and status connected
And WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId2 and status connected

Scenario: Clear buffers
When WS1 clears all text messages from buffer named CallStatusIndicationBuffer1
When WS2 clears all text messages from buffer named CallStatusIndicationBuffer2
When WS3 clears all text messages from buffer named CallStatusIndicationBuffer3

Scenario: Second client puts the call on hold
		  @REQUIREMENTS:GID-2604614
When WS2 puts the phone call with the callId outgoingPhoneCallId2 on hold
And waiting for 2 seconds

Scenario: Verify call is not put on hold
Then WS1 has on the message buffer named CallStatusIndicationBuffer1 a number of 0 messages
Then WS2 has on the message buffer named CallStatusIndicationBuffer2 a number of 0 messages
Then WS3 has on the message buffer named CallStatusIndicationBuffer3 a number of 0 messages

Scenario: Cleanup calls
When WS1 clears the phone call with the callId outgoingPhoneCallId1
When WS3 clears the phone call with the callId outgoingPhoneCallId2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
When the named websocket WS3 removes the message buffer named CallStatusIndicationBuffer3

