Narrative:
As an operator having an IA call with another operator
I want to transfer the IA call
So I can verify that the transfer is not possible and the IA call is not affected

Meta:
     @BeforeStory: ../includes/@PrepareTwoClientsWithMissions.story
     @AfterStory: ../includes/@CleanupTwoClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2

Scenario: Clients retrieve phone data
When WS1 loads phone data for role roleId1 and names callSourceCalling and callTargetCalling from the entry number 1
When WS2 loads phone data for role roleId2 and names callSourceCalled and callTargetCalled from the entry number 1

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing IA call with source callSourceCalling and target callTargetCalling and names outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 is receiving call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status connected and audio direction TX

Scenario: Callee client receives the incoming call
When WS2 receives call incoming indication for IA call on message buffer named CallIncomingIndicationBuffer2 with callSourceCalling and callTargetCalling and names incomingPhoneCallId1 and audio direction RX

Scenario: Callee establishes an outgoing call
When WS2 establishes an outgoing IA call with source callSourceCalled and target callTargetCalled and names outgoingPhoneCallId2
And waiting for 1 seconds
Then WS2 is receiving call status indication on message buffer named CallStatusIndicationBuffer2 with callId outgoingPhoneCallId2 and status connected and audio direction DUPLEX

Scenario: Caller client receives the incoming call
When WS1 receives call incoming indication for IA call on message buffer named CallIncomingIndicationBuffer1 with callSourceCalled and callTargetCalled and names incomingPhoneCallId2 and audio direction DUPLEX

Scenario: Callee operator puts the call on hold with call conditional flag
		  @REQUIREMENTS:GID-2510076
		  @REQUIREMENTS:GID-2510078
When WS1 puts the phone call with the callId outgoingPhoneCallId1 on hold with call conditional flag xfr

Scenario: Verify call is not put on hold with call conditional flag
Then WS1 has on the message buffer named CallStatusIndicationBuffer1 a number of 0 messages
Then WS2 has on the message buffer named CallStatusIndicationBuffer2 a number of 0 messages

Scenario: Callee operator puts the call on hold with call conditional flag
When WS2 puts the phone call with the callId outgoingPhoneCallId2 on hold with call conditional flag xfr

Scenario: Verify call is not put on hold with call conditional flag
Then WS2 has on the message buffer named CallStatusIndicationBuffer2 a number of 0 messages
Then WS1 has on the message buffer named CallStatusIndicationBuffer1 a number of 0 messages

Scenario: Cleanup phone calls
When WS1 clears the phone call with the callId outgoingPhoneCallId1
When WS2 clears the phone call with the callId outgoingPhoneCallId2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
When the named websocket WS1 removes the message buffer named CallIncomingIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
