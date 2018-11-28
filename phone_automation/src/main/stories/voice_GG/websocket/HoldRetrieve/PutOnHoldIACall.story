Narrative:
As an operator having an outgoing IA call
I want to put the IA call on hold
So I can verify that the call is not put on hold

Meta:
     @BeforeStory: ../includes/@PrepareTwoClientsWithMissions.story
     @AfterStory: ../includes/@CleanupTwoClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget from the entry number 1

Scenario: Caller establishes an outgoing IA call
When WS1 establishes an outgoing IA call with source callSource and target callTarget and names outgoingPhoneCallId
And waiting for 1 seconds
Then WS1 is receiving call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status connected and audio direction TX

Scenario: Callee client receives the incoming call
When WS2 receives call incoming indication for IA call on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId and audio direction RX

Scenario: Clear buffers
When WS1 clears all text messages from buffer named CallStatusIndicationBuffer1
When WS2 clears all text messages from buffer named CallStatusIndicationBuffer2

Scenario: Caller client puts the call on hold
		  @REQUIREMENTS:GID-2505734
When WS1 puts the phone call with the callId outgoingPhoneCallId on hold
And waiting for 2 seconds

Scenario: Verify call is unchanged
Then WS1 has on the message buffer named CallStatusIndicationBuffer1 a number of 0 messages
Then WS2 has on the message buffer named CallStatusIndicationBuffer2 a number of 0 messages

Scenario: Cleanup phone call
When WS1 clears the phone call with the callId outgoingPhoneCallId

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
