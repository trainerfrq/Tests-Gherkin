Narrative:
As a transferor operator having a ringing call with a transferee operator
I want to transfer the ringing call
So I can verify that the transfer is not possible and the ringing call is not affected

Meta:
     @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
     @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller operator retrieves phone data
When WS1 loads phone data for mission missionId1 and names callSource1 and callTarget1 from the entry number 1

Scenario: Caller operator establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource1 ang target callTarget1 and names outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_trying

Scenario: Callee operator receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource1 and callTarget1 and names incomingPhoneCallId1
And WS2 confirms incoming phone call with callId incomingPhoneCallId1
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_ringing

Scenario: Caller operator puts the call on hold with call conditional flag
		  @REQUIREMENTS:GID-2510076
		  @REQUIREMENTS:GID-2510078
When WS1 puts the phone call with the callId outgoingPhoneCallId1 on hold with call conditional flag xfr

Scenario: Verify call is not put on hold with call conditional flag
Then WS1 has on the message buffer named CallStatusIndicationBuffer1 a number of 1 messages
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_ringing
Then WS2 has on the message buffer named CallStatusIndicationBuffer2 a number of 0 messages
Then WS2 has on the message buffer named CallIncomingIndicationBuffer2 a number of 0 messages

Scenario: Verify call can be answered by callee operator
When WS2 answers the incoming phone call with the callId incomingPhoneCallId1
And waiting for 1 seconds
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status connected
And WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status connected

Scenario: Clear calls
When WS1 clears the phone call with the callId outgoingPhoneCallId1
And waiting for 1 seconds

Scenario: Call is terminated
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status terminated
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status terminated

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
