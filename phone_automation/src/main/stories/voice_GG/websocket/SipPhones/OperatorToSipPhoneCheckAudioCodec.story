Meta: @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
	  @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget from the entry number 1

Scenario: Define call target
When define values in story data:
| name         | value          |
| calledTarget | <<SIP_PHONE1>> |

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target calledTarget and names outgoingPhoneCallId
And waiting for 3 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Check if invite with SDP header containing the codec is received
		  @REQUIREMENTS:GID-2538205
Then SipContact DialogState is EARLY within 100 ms
Then SipContact receives 8 PCMA/8000 within rtpMap of the SDP received in SIP INVITE message

Scenario: Sip phone rejects the phone call
When SipContact declines calls
Then SipContact DialogState is TERMINATED within 100 ms
And waiting for 3 seconds
Then WS1 receives call status indication with out_failed status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails busy

Scenario: Caller client clears the phone call
When WS1 clears the phone call with the callId outgoingPhoneCallId
And waiting for 3 seconds
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails busy

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
