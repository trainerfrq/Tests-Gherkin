Narrative:
As a caller operator
I want to initiate an IA call
So I can verify that the call is terminated if no SIP response is received in a given timer interval

Meta:
     @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
     @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget from the entry number 1

Scenario: Define call target
When define values in story data:
| name           | value          |
| sipPhoneTarget | <<SIP_PHONE1>> |

Scenario: Caller establishes an outgoing call
		  @REQUIREMENTS:GID-2505705
When WS1 establishes an outgoing IA call with source callSource and target sipPhoneTarget and names outgoingPhoneCallId
And waiting for 3 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_failed

Scenario: Clear call
When WS1 clears the phone call with the callId outgoingPhoneCallId

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer
