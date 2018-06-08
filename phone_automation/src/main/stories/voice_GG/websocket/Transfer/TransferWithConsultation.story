Narrative:
As an transferor operator having an active call with a transferee operator
I want to transfer the active call to a transfer target with an intermediary consultation call
So I can verify that the transfer was successful

Meta:
     @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
     @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2
When WS3 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer3
When WS3 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer3

Scenario: Transferor retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource1 and callTarget1 from the entry number 1
When WS1 loads phone data for role roleId1 and names callSource2 and callTarget2 from the entry number 3

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
When WS1 puts the phone call with the callId outgoingPhoneCallId1 on hold with call conditional flag
And waiting for 2 seconds

Scenario: Verify call is on hold
Then WS1 receives call status indication with call conditional flag on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status hold
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status held

Scenario: Transferor establishes consultation call
When WS1 establishes an outgoing phone call with call conditional flag using source callSource2 ang target callTarget2 and names outgoingPhoneCallId2
And waiting for 1 seconds
Then WS1 receives call status indication with call conditional flag on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status out_trying

Scenario: Transfer target receives the incoming call and confirms it
When WS3 receives call incoming indication on message buffer named CallIncomingIndicationBuffer3 with callSource2 and callTarget2 and names incomingPhoneCallId2
And WS3 confirms incoming phone call with callId incomingPhoneCallId2
Then WS1 receives call status indication with call conditional flag on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status out_ringing

Scenario: Transfer target answers the incoming call
When WS3 answers the incoming phone call with the callId incomingPhoneCallId2
And waiting for 1 seconds
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer3 with callId incomingPhoneCallId2 and status connected
And WS1 receives call status indication with call conditional flag on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status connected

Scenario: Empty buffers
When WS1 clears all text messages from buffer named CallStatusIndicationBuffer1
When WS2 clears all text messages from buffer named CallStatusIndicationBuffer2
When WS2 clears all text messages from buffer named CallIncomingIndicationBuffer2
When WS3 clears all text messages from buffer named CallStatusIndicationBuffer3
When WS3 clears all text messages from buffer named CallIncomingIndicationBuffer3

Scenario: Transferor transfers the call
When WS1 transfers the phone call with the transferee callId outgoingPhoneCallId1 and transfer target callId outgoingPhoneCallId2
Then waiting for 2 seconds

Scenario: Verify messages on transferor side
!-- TODO QXVP-8546 Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status hold
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId2 and status terminated
Then WS1 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status terminated

Scenario: Verify messages on transferee side
Then WS2 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId1 and status terminated
When WS2 receives connected call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callTarget2 and callTarget1 and names transferCallId1

Scenario: Verify messages on transfer target side
!-- TODO QXVP-8546 Then WS3 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer3 with callId incomingPhoneCallId2 and status held
Then WS3 receives call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer3 with callId incomingPhoneCallId2 and status terminated
!-- TODO QXVP-8961 When WS3 receives connected call incoming indication on message buffer named CallIncomingIndicationBuffer3 with callTarget1 and callTarget2 and names transferCallId2

Scenario: Cleanup call
When WS2 clears the phone call with the callId transferCallId1
!-- TODO QXVP-8961 When WS3 clears the phone call with the callId transferCallId2
