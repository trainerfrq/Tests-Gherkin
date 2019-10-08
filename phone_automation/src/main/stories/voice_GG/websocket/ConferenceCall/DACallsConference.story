Narrative:
As an operator having an active call with another operator
I want to change the call into a conference call and add a third participant
So I can verify that conference works as expected

Meta:
	  @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS1 opens the message buffer for message type confStatusIndication named ConfStatusIndicationBuffer1
When WS1 opens the message buffer for message type confAddPartyResponse named ConfAddPartyResponseBuffer1

When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2
When WS2 opens the message buffer for message type confStatusIndication named ConfStatusIndicationBuffer2

When WS3 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer3
When WS3 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer3

Scenario: Operator 1 retrieves phone data
When WS1 queries phone data for mission missionId1 in order to call OP2 and names them callSource1 and callTarget1
When WS1 queries phone data for mission missionId1 in order to call OP3 and names them callSource2 and callTarget2

Scenario: Operator 1 establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource1 ang target callTarget1 and names outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_trying

Scenario: Operator 2 receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource1 and callTarget1 and names incomingPhoneCallId1
And WS2 confirms incoming phone call with callId incomingPhoneCallId1
And waiting for 1 second
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_ringing

Scenario: Operator 2 answers the incoming call
When WS2 answers the incoming phone call with the callId incomingPhoneCallId1
And waiting for 1 seconds
Then WS2 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status connected
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status connected

Scenario: Operator 1 establishes a conference call
When WS1 establishes a conference call using callId outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status hold

Scenario: Operator 2 receives the incoming conference call and confirms it
Then WS2 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status held
Then WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with the flag conf and names incomingPhoneCallId2
When WS2 confirms incoming phone call with callId incomingPhoneCallId2
And waiting for 1 second

Scenario: Operator 1 receives conference status indications
When WS1 receives conference status indication with status connected and type broadcast on buffer named ConfStatusIndicationBuffer1 and names confCallId1
When WS1 receives conference status indication with confId confCallId1 , source callSource1 , target callTarget1 and status ringing on message buffer named ConfStatusIndicationBuffer1
When WS1 receives conference status indication with confId confCallId1 and source callSource1 , target callTarget1 on message buffer named ConfStatusIndicationBuffer1 with status connected for both parties

Scenario: Operator 1 adds the third operator to the conference
When WS1 establish a conference add party request to conference with confId confCallId1 with source callSource2 and target op3@example.com
And waiting for 5 seconds
Then WS1 receives conference add party response on message buffer named ConfAddPartyResponseBuffer1 with source callSource2 and target callTarget2 and result processing

Scenario: Operator 3 receives the incoming conference call and confirms it
Then WS3 receives call incoming indication on message buffer named CallIncomingIndicationBuffer3 with the flag conf and names incomingPhoneCallId3
When WS3 confirms incoming phone call with callId incomingPhoneCallId3
When WS3 answers the incoming phone call with the callId incomingPhoneCallId3
And waiting for 3 seconds
Then WS1 receives conference status indication messages with status connected for all the participants on buffer named ConfStatusIndicationBuffer1

Scenario: Operator 1 leaves the conference
When WS1 clears the phone call with the callId confCallId1
And waiting for 1 second
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and terminationDetails normal

Scenario: Operator 2 checks the status of the call with operator 3
When WS2 receives conference status indication messages with status connected for remaining participants on buffer named ConfStatusIndicationBuffer2

Scenario: Operator 3 leaves the conference
When WS3 clears the phone call with the callId incomingPhoneCallId3
And waiting for 1 second
Then WS2 receives conference status indication message with conference status terminated on buffer named ConfStatusIndicationBuffer2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS1 removes the message buffer named ConfStatusIndicationBuffer1
When the named websocket WS1 removes the message buffer named ConfAddPartyResponseBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
When the named websocket WS2 removes the message buffer named ConfStatusIndicationBuffer2
When the named websocket WS3 removes the message buffer named CallIncomingIndicationBuffer3
When the named websocket WS3 removes the message buffer named CallStatusIndicationBuffer3
