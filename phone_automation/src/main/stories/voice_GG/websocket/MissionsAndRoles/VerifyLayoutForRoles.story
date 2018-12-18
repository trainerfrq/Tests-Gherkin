Narrative:
As a an operator
I want to check the layout using different roles
So that I can verify that each role shall have assigned a different layout

Meta:
	  @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type roleLayoutResponse named RoleLayoutResponseBuffer1
When WS2 opens the message buffer for message type roleLayoutResponse named RoleLayoutResponseBuffer2
When WS3 opens the message buffer for message type roleLayoutResponse named RoleLayoutResponseBuffer3

Scenario: Operator 1 requests the layout
When WS1 requests the layout for role roleId1 and saves the request requestId1

Scenario: Operator 1 receives the response
Then WS1 receives layout response on buffer named RoleLayoutResponseBuffer1 for request with requestId1 and saves the layout in response1

Scenario: Operator 2 requests the layout
When WS2 requests the layout for role roleId2 and saves the request requestId2

Scenario: Operator 2 receives the response
Then WS2 receives layout response on buffer named RoleLayoutResponseBuffer2 for request with requestId2 and saves the layout in response2

Scenario: Operator 3 requests the layout
When WS3 requests the layout for role roleId3 and saves the request requestId3

Scenario: Operator 3 receives the response
Then WS3 receives layout response on buffer named RoleLayoutResponseBuffer3 for request with requestId3 and saves the layout in response3

Scenario: Assert that layouts for operators 1 and 3 (same role) are the same
		  @REQUIREMENTS:GID-2398732
Then verify that responses response1 and response3 are equal

Scenario: Assert that layouts for operators 1 and 2 (different roles) are different
Then verify that responses response1 and response2 are different

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named RoleLayoutResponseBuffer1
When the named websocket WS2 removes the message buffer named RoleLayoutResponseBuffer2
When the named websocket WS3 removes the message buffer named RoleLayoutResponseBuffer3
