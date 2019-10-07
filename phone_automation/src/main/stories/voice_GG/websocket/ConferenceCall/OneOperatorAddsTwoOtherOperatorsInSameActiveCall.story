Narrative:
As an operator having an active call with another operator
I want to add a third operator in the same active call
So I can verify that all operators are active in the same call

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

Scenario: First client retrieves phone data
When WS1 queries phone data for mission missionId1 in order to call OP2 and names them callSource1 and callTarget1
When WS1 queries phone data for mission missionId1 in order to call OP3 and names them callSource2 and callTarget2

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

Scenario: First client establishes a conference call
When WS1 establishes a conference call using callId outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status hold

Scenario: Second client receives the incoming call and confirms it
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status held
Then WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with the flag conf and names incomingPhoneCallId2
Then WS2 confirms incoming phone call with callId incomingPhoneCallId2
And waiting for 1 second

Scenario: First client receives conference status indications
When WS1 receives conference status indication with status connected and type broadcast on buffer named ConfStatusIndicationBuffer1 and names confCallId1
When WS1 receives conference status indication with confCallId1 , callingParty callSource1 , calledParty callTarget1 and state ringing on message buffer named ConfStatusIndicationBuffer1
When WS1 receives conference status indication with confCallId1 and callingParty callSource1 , calledParty callTarget1 on message buffer named ConfStatusIndicationBuffer1 with status connected for both parties

Scenario: First client adds the third client to the conference
When WS1 establish a conference add party request to conference confCallId1 with callingParty callSource2 and calledParty op3@example.com
And waiting for 5 seconds
Then WS1 receives conference add party response on message buffer named ConfAddPartyResponseBuffer1 with callSource2 and callTarget2 and result processing
Then WS3 receives call incoming indication on message buffer named CallIncomingIndicationBuffer3 with the flag conf and names incomingPhoneCallId3
Then WS3 confirms incoming phone call with callId incomingPhoneCallId3
Then WS3 accepts the incoming phone call with callId incomingPhoneCallId3
And waiting for 3 seconds
Then WS1 receives conference status indication messages with status connected for all the participants on buffer named ConfStatusIndicationBuffer1

Scenario: First operator leaves the conference
When WS1 clears the phone call with the callId confCallId1
And waiting for 1 second
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and terminationDetails normal

Scenario: Third operator leaves the conference
When WS3 clears the phone call with the callId incomingPhoneCallId3
And waiting for 1 second
Then WS2 receives conference status indication message with conference status terminated on buffer named ConfStatusIndicationBuffer2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS1 removes the message buffer named ConfStatusIndicationBuffer1
When the named websocket WS1 removes the message buffer named ConfAddPartyResponseBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
