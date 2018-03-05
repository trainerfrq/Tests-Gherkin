Narrative:
As an operator having a phone call with out_failed status
I want to clear the phone call
So that I can verify that the phone call has terminated status

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
And waiting for 3 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Sip phone rejects the phone call
When SipContact declines calls
Then SipContact DialogState is TERMINATED within 100 ms
And waiting for 3 seconds
Then WS1 receives call status indication with out_failed status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails busy

Scenario: Callee client clears the phone call
When WS1 clears the phone call with the callId outgoingPhoneCallId

Scenario: Verify call is terminated
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails busy

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
