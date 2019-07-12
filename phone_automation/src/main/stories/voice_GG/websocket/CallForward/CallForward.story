Meta: @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Create the message buffer for call forward
When WS1 opens the message buffer for message type callForwardStatus named callForwardStatusBuffer

Scenario: Forwarding client retrieves phone data
When WS1 loads phone data for mission missionId1 and names callSource and callTarget from the entry number 1

Scenario: Send Call Forward Request
		  @REQUIREMENTS:GID-2521111
When WS1 sends a call forward request to another operator with callTarget
Then WS1 receives a call forward status on message buffer named callForwardStatusBuffer with status active

Scenario: Create the message buffer to check if the first operator doesn't receive any call
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1

Scenario: Create the message buffers for call
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2
When WS3 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer3

Scenario: Caller retrieves phone data
When WS3 loads phone data for mission missionId1 and names callSource3 and callTarget3 from the entry number 1

Scenario: Caller establishes an outgoing call
When WS3 establishes an outgoing phone call using source callSource3 ang target callSource and names outgoingPhoneCallId
And waiting for 6 seconds
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId and status out_trying

Scenario: Callee client receives the incoming call and confirms it
Then WS1 has on the message buffer named CallIncomingIndicationBuffer1 a number of 0 messages
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource3 and callTarget3 and names incomingPhoneCallId
And WS2 confirms incoming phone call with callId incomingPhoneCallId
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId and status out_ringing

Scenario: Callee client answers the incoming call
When WS2 answers the incoming phone call with the callId incomingPhoneCallId
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and status connected
And WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId and status connected

Scenario: Callee client clears the phone call
When WS2 clears the phone call with the callId incomingPhoneCallId
And waiting for 3 seconds
Then WS3 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId and terminationDetails normal
Then WS2 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and terminationDetails normal

Scenario: Client cancels the call forward
When WS1 sends a call forward cancel request
Then WS1 receives a call forward status on message buffer named callForwardStatusBuffer with status inactive

Scenario: Create message buffer for call
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1

Scenario: Caller establishes an outgoing call
When WS3 establishes an outgoing phone call using source callSource3 ang target callSource and names outgoingPhoneCallId2
And waiting for 6 seconds
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId2 and status out_trying

Scenario: Callee client receives the incoming call and confirms it
When WS1 receives call incoming indication on message buffer named CallIncomingIndicationBuffer1 with callSource3 and callSource and names incomingPhoneCallId1
And WS1 confirms incoming phone call with callId incomingPhoneCallId1
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId2 and status out_ringing

Scenario: Callee client answers the incoming call
When WS1 answers the incoming phone call with the callId incomingPhoneCallId1
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId incomingPhoneCallId1 and status connected
And WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId2 and status connected

Scenario: Callee client clears the phone call
When WS1 clears the phone call with the callId incomingPhoneCallId1
And waiting for 3 seconds
Then WS3 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer3 with callId outgoingPhoneCallId2 and terminationDetails normal
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId incomingPhoneCallId1 and terminationDetails normal

Scenario: Delete message buffers
When the named websocket WS1 removes the message buffer named callForwardStatusBuffer
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
When the named websocket WS3 removes the message buffer named CallStatusIndicationBuffer3
