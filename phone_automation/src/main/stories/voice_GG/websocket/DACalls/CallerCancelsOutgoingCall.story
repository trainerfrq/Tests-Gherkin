Narrative:
As a caller operator having an outgoing phone call to a callee operator
I want to cancel the phone call
So I can verify that the phone call is terminated on both sides

Meta: @BeforeStory: ../includes/@PrepareTwoClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupTwoClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget from the entry number 1

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target callTarget and names outgoingPhoneCallId
And waiting for 6 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_trying

Scenario: Callee client receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId
And WS2 confirms incoming phone call with callId incomingPhoneCallId
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Caller client clears the incoming call
		  @REQUIREMENTS:GID-2510109
When WS1 clears the phone call with the callId outgoingPhoneCallId
And waiting for 3 seconds
Then WS2 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and terminationDetails normal
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails normal

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2