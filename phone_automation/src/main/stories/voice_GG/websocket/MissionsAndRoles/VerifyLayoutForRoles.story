Narrative:
As a an operator
I want to check the layout using different roles
So that I can verify that each role shall have assigned a different layout

Meta:
	  @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Request layout for first operator
When WS1 requests the layout for role roleId1 and saves the request request1

Scenario: Request layout for second operator
When WS2 requests the layout for role roleId2 and saves the request request2

Scenario: Request layout for third operator
When WS3 requests the layout for role roleId1 and saves the request request3

Scenario: Assert that layouts for operators 1 and 3 (same role) are the same
		  @REQUIREMENTS:GID-2398732
Then verify that responses for request1 and request3 are equal

Scenario: Assert that layouts for operators 1 and 2 (different roles) are different
Then verify that responses for request1 and request2 are different
