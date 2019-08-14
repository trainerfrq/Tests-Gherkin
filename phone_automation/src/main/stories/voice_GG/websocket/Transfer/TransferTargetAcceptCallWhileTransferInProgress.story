Narrative:
As a transfer target operator having an on hold consultation call
I want to accept another call
So I can verify that the consultation call will not be auto-terminated

Meta:
     @BeforeStory: ../includes/@PrepareThreeClientsWithMissionsAndSipPhone.story
     @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2
When WS3 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer3
When WS3 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer3

Scenario: Transferor retrieves phone data
When WS1 queries phone data for mission missionId1 in order to call OP2 and names them callSource1 and callTarget1
When WS1 queries phone data for mission missionId1 in order to call OP3 and names them callSource2 and callTarget2

Scenario: Transferor establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource1 ang target callTarget1 and names outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_trying

Scenario: Transferee receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource1 and callTarget1 and names incomingPhoneCallId1
And WS2 confirms incoming phone call with callId incomingPhoneCallId1
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status out_ringing

Scenario: Transferee answers the incoming call
When WS2 answers the incoming phone call with the callId incomingPhoneCallId1
And waiting for 1 seconds
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status connected
And WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status connected

Scenario: Transferor puts the call on hold with call conditional flag
When WS1 puts the phone call with the callId outgoingPhoneCallId1 on hold with call conditional flag xfr
And waiting for 2 seconds

Scenario: Verify call is on hold
Then WS1 receives call status indication with call conditional flag xfr on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status hold
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status held

Scenario: Transferor establishes consultation call
		  @REQUIREMENTS:GID-2510076
		  @REQUIREMENTS:GID-2510077
When WS1 establishes an outgoing phone call with call conditional flag xfr using source callSource2 ang target callTarget2 and names outgoingPhoneCallId2
And waiting for 1 seconds
Then WS1 receives call status indication with call conditional flag xfr on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status out_trying

Scenario: Transfer target receives the incoming call and confirms it
When WS3 receives call incoming indication on message buffer named CallIncomingIndicationBuffer3 with callSource2 and callTarget2 and names incomingPhoneCallId2
And WS3 confirms incoming phone call with callId incomingPhoneCallId2
Then WS1 receives call status indication with call conditional flag xfr on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status out_ringing

Scenario: Transfer target answers the incoming call
When WS3 answers the incoming phone call with the callId incomingPhoneCallId2
And waiting for 1 seconds
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId incomingPhoneCallId2 and status connected
And WS1 receives call status indication with call conditional flag xfr on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status connected

Scenario: Empty buffers
When WS1 clears all text messages from buffer named CallStatusIndicationBuffer1
When WS2 clears all text messages from buffer named CallStatusIndicationBuffer2
When WS2 clears all text messages from buffer named CallIncomingIndicationBuffer2
When WS3 clears all text messages from buffer named CallStatusIndicationBuffer3
When WS3 clears all text messages from buffer named CallIncomingIndicationBuffer3

Scenario: Sip phone calls transferor
When SipContact calls SIP URI <<OPVOICE3_PHONE_URI>>

Scenario: Define call source and target
When define values in story data:
| name         | value    |
| calledSource | sip:cats |
| calledTarget | sip:op3  |

Scenario: Transfer target receives the incoming call and confirms it
When WS3 receives call incoming indication on message buffer named CallIncomingIndicationBuffer3 with calledSource and calledTarget and names phoneIncomingCallId
And WS3 confirms incoming phone call with callId phoneIncomingCallId
Then SipContact DialogState is EARLY within 100 ms

Scenario: Transferee puts on hold consultation call
When WS3 puts the phone call with the callId incomingPhoneCallId2 on hold
And waiting for 1 seconds

Scenario: Consultation call is put on hold
Then WS1 receives call status indication with call conditional flag xfr on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status held
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId incomingPhoneCallId2 and status hold

Scenario: Transfer target answers the incoming call
When WS3 answers the incoming phone call with the callId phoneIncomingCallId
And waiting for 1 seconds
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId phoneIncomingCallId and status connected
Then SipContact DialogState is CONFIRMED within 100 ms

Scenario: Verify consultation call is not auto-terminated
Then WS1 has on the message buffer named CallStatusIndicationBuffer1 a number of 0 messages
Then WS3 has on the message buffer named CallStatusIndicationBuffer3 a number of 0 messages

Scenario: Sip phone terminates the phone call
When SipContact terminates calls
And waiting for 2 seconds
Then WS3 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer3 with callId phoneIncomingCallId and terminationDetails normal

Scenario: Transfer target retrieves from hold consultation call
When WS3 retrieves the on hold phone call with the callId incomingPhoneCallId2
And waiting for 1 seconds

Scenario: Consultation call is retrieved from hold
Then WS1 receives call status indication with call conditional flag xfr on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status connected
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId incomingPhoneCallId2 and status connected

Scenario: Cleanup calls
When WS1 clears the phone call with the callId outgoingPhoneCallId1
When WS1 clears the phone call with the callId outgoingPhoneCallId2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2
When the named websocket WS3 removes the message buffer named CallIncomingIndicationBuffer3
When the named websocket WS3 removes the message buffer named CallStatusIndicationBuffer3

Scenario: Remove sip phone
When SipContact is removed
