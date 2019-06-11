Narrative:
As a callee operator having an incoming phone call with a caller operator
I want to disassociate from Op Voice Service
So I can verify that the phone call is terminated for the caller operator

Meta: @BeforeStory: ../includes/@PrepareTwoClientsWithMissions.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS1 loads phone data for mission missionId1 and names callSource and callTarget from the entry number 1

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target callTarget and names outgoingPhoneCallId
And waiting for 6 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_trying

Scenario: Callee client receives the incoming call
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId

Scenario: Callee client disassociates from OP Voice
		  @REQUIREMENTS:GID-2510109
When WS2 disassociates from Op Voice Service
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_failed

Scenario: Cleanup
When WS1 disassociates from Op Voice Service

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection
When WS2 closes websocket client connection


