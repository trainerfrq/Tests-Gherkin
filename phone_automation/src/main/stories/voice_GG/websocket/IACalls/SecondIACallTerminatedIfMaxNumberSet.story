Narrative:
As a caller operator having an outgoing IA Call towards a callee operator having maximum incoming IA call count set to one
I want to initiate another IA call to the same callee operator
So I can verify that the second call is terminated automatically and the first call remains unchanged

Meta:
     @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
     @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS3 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS1 loads phone data for mission missionId1 and names callSource and callTarget from the entry number 1
When WS3 loads phone data for mission missionId2 and names callSource2 and callTarget2 from the entry number 11

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing IA call with source callSource and target callTarget and names outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 is receiving call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status connected and audio direction TX

Scenario: Callee client receives the incoming call and confirms it
When WS2 receives call incoming indication for IA call on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId and audio direction RX

Scenario: Another caller establishes an IA call to operator 2
When WS3 establishes an outgoing IA call with source callSource2 and target callTarget2 and names outgoingPhoneCallId2
And waiting for 1 seconds

Scenario: Verify call status
		  @REQUIREMENTS:GID-2505707
Then WS3 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer2 with callId outgoingPhoneCallId2 and status out_failed
And waiting for 1 seconds
Then WS1 has on the message buffer named CallStatusIndicationBuffer1 a number of 0 messages
Then WS2 has on the message buffer named CallIncomingIndicationBuffer2 a number of 0 messages

Scenario: Cleanup phone call
When WS1 clears the phone call with the callId outgoingPhoneCallId1

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS3 removes the message buffer named CallStatusIndicationBuffer2
