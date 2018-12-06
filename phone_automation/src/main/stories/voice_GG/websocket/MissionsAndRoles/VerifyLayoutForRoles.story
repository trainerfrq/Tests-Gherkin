Narrative:
As a an operator
I want to check the layout using different roles
So that I can verify that each role shall have assigned a different layout

Meta:
	  @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type roleLayoutResponse named roleLayoutResponseBuffer1

Scenario: Request layout for first operator
When WS1 requests the layout for role roleId1 and saves the request response1

Scenario: Create the message buffers
When WS2 opens the message buffer for message type roleLayoutResponse named roleLayoutResponseBuffer2

Scenario: Request layout for second operator
When WS2 requests the layout for role roleId2 and saves the request response2

Scenario: Create the message buffers
When WS3 opens the message buffer for message type roleLayoutResponse named roleLayoutResponseBuffer3

Scenario: Request layout for third operator
When WS3 requests the layout for role roleId1 and saves the request response3

Scenario: Assert that requestId1 and requestId3 are equal
		  @REQUIREMENTS:GID-2398732
Then verify that response1 and response3 are equal

Scenario: Assert that requestId1 and requestId2 are different
Then verify that response1 and response2 are different

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named roleLayoutResponseBuffer1
When the named websocket WS2 removes the message buffer named roleLayoutResponseBuffer2
When the named websocket WS3 removes the message buffer named roleLayoutResponseBuffer3
