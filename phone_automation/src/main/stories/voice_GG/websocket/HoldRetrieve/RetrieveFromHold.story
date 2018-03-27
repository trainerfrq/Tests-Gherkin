Narrative:
As an operator having a call on hold with another operator
I want to retrieve the call from hold
So I can verify that the call state is connected for both operators

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
When WS1 establishes an outgoing phone call using source callSource ang target callTarget and names outgoingPhoneCallId
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_trying

Scenario: Callee client receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId
And WS2 confirms incoming phone call with callId incomingPhoneCallId
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Callee client answers the incoming call
When WS2 answers the incoming phone call with the callId incomingPhoneCallId
And waiting for 1 seconds
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and status connected
And WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status connected

Scenario: Caller client puts the call on hold
When WS1 puts the phone call with the callId outgoingPhoneCallId on hold
And waiting for 2 seconds

Scenario: Verify call is on hold
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status hold
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and status held

Scenario: Caller client retrieves call from hold
		  @REQUIREMENTS:GID-2510075
When WS1 retrieves the on hold phone call with the callId outgoingPhoneCallId
And waiting for 1 seconds

Scenario: Verify call is connected
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status connected
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and status connected

Scenario: Cleanup call
When WS1 clears the phone call with the callId outgoingPhoneCallId

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2

