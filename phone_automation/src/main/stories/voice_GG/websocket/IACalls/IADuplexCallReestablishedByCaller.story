Narrative:
As a caller operator having an incoming one-way IA Call resulting from the termination of a duplex IA Call by me
I want to establish an outgoing IA Call towards the caller operator
So that I can verify that the duplex IA Call is reestablished

Meta:
     @BeforeStory: ../includes/@PrepareTwoClientsWithMissions.story
     @AfterStory: ../includes/@CleanupTwoClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2

Scenario: Clients retrieve phone data
When WS1 queries phone data for mission missionId1 in order to call IA - OP2 and names them callSourceCalling and callTargetCalling
When WS2 queries phone data for mission missionId2 in order to call IA - OP1 and names them callSourceCalled and callTargetCalled

Scenario: Caller establishes an outgoing call
		  @REQUIREMENTS:GID-2505705
When WS1 establishes an outgoing IA call with source callSourceCalling and target callTargetCalling and names callId1
And waiting for 1 seconds
Then WS1 is receiving call status indication on message buffer named CallStatusIndicationBuffer1 with callId callId1 and status connected and audio direction TX

Scenario: Callee client receives the incoming call
When WS2 receives call incoming indication for IA call on message buffer named CallIncomingIndicationBuffer2 with callSourceCalling and callTargetCalling and names callId2 and audio direction RX

Scenario: Callee establishes an outgoing call
When WS2 establishes an outgoing IA call with source callSourceCalled and target callTargetCalled and names callId2
And waiting for 1 seconds
Then WS2 is receiving call status indication on message buffer named CallStatusIndicationBuffer2 with callId callId2 and status connected and audio direction DUPLEX

Scenario: Caller client receives the duplex call
When WS1 receives call incoming indication for IA call on message buffer named CallIncomingIndicationBuffer1 with callSourceCalled , callTargetCalled , audio direction DUPLEX and monitoring type GG and names incomingPhoneCallId2

Scenario: Caller client clears the phone call
When WS1 clears the phone call with the callId callId1
And waiting for 1 seconds
Then WS1 is receiving call status indication on message buffer named CallStatusIndicationBuffer1 with callId callId1 and status connected and audio direction RX_MONITORED
Then WS2 is receiving call status indication on message buffer named CallStatusIndicationBuffer2 with callId callId2 and status connected and audio direction TX_MONITORED

Scenario: Caller reestablishes the phone call
When WS1 establishes an outgoing IA call with source callSourceCalling and target callTargetCalling and names callId1
And waiting for 1 seconds
Then WS1 is receiving call status indication on message buffer named CallStatusIndicationBuffer1 with callId callId1 and status connected and audio direction DUPLEX

Scenario: Callee client receives the duplex call
When WS2 receives call incoming indication for IA call on message buffer named CallIncomingIndicationBuffer2 with callSourceCalling and callTargetCalling and names callId2 and audio direction DUPLEX

Scenario: Cleanup phone calls
When WS1 clears the phone call with the callId callId1
When WS2 clears the phone call with the callId callId2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
When the named websocket WS1 removes the message buffer named CallIncomingIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
