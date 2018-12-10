Narrative:
As an operator having a call on hold with another operator
I want to retrieve the call from hold
So I can verify that the call state is connected for both operators

Meta:
     @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
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
And waiting for 1 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_trying

Scenario: Sip phone accepts the phone call
When SipContact answers incoming calls
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status connected
Then SipContact DialogState is CONFIRMED within 100 ms

Scenario: Caller client puts the call on hold
		  @REQUIREMENTS:GID-2505734
When WS1 puts the phone call with the callId outgoingPhoneCallId on hold
And waiting for 2 seconds

Scenario: Sip phone rejects the hold
When SipContact declines calls
And waiting for 3 seconds
Then WS1 does NOT receive call status indication verifying all the messages on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status hold

Scenario: Cleanup call
When WS1 clears the phone call with the callId outgoingPhoneCallId

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
