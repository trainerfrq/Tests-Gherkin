Narrative:
As a caller operator
I want to initiate an IA call
So I can verify that is automatically accepted

Meta:
     @BeforeStory: ../includes/@PrepareTwoClientsWithMissions.story
     @AfterStory: ../includes/@CleanupTwoClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget from the entry number 1

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing IA call with source callSource and target callTarget and names outgoingPhoneCallId
And waiting for 1 seconds
Then WS1 is receiving call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status connected and audio direction TX

Scenario: Callee client receives the incoming call and confirms it
When WS2 receives call incoming indication for IA call on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId and audio direction RX
And WS2 confirms incoming phone call with callId incomingPhoneCallId

Scenario: Cleanup phone call
When WS1 clears the phone call with the callId outgoingPhoneCallId

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
