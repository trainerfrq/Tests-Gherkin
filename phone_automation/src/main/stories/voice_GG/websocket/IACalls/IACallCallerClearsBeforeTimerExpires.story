Narrative:
As a caller operator
I want to clear an initiated IA call
So I can verify that the call is terminated

Meta:
     @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
     @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget from the entry number 1

Scenario: Define call target
When define values in story data:
| name           | value                         |
| sipPhoneTarget | sip:cats@<<PHONE_ROUTING_IP>> |

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing IA call with source callSource and target sipPhoneTarget and names outgoingPhoneCallId

Scenario: Caller clears phone call
When WS1 clears the phone call with the callId outgoingPhoneCallId
When waiting for 1 seconds

Scenario: Verify phone call is terminated
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status terminated

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
