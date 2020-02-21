Narrative:
As a an operator
I want to check the layout using different roles
So that I can verify that each role shall have assigned a different layout

Meta:
	  @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Request and receive layout for first operator
When WS1 requests the layout for mission missionId1 and saves the response response1

Scenario: Request and receive layout for second operator
When WS2 requests the layout for mission missionId2 and saves the response response2

Scenario: Request and receive layout for third operator
When WS3 requests the layout for mission missionId3 and saves the response response3

Scenario: Assert that layouts for operators 1 and 3 (different roles) are different
		  @REQUIREMENTS:GID-2398732
Then verify that responses response1 and response3 are diffrent

Scenario: Assert that layouts for operators 1 and 2 (different roles) are different
Then verify that responses response1 and response2 are different

Scenario: Assert that layouts for operators 2 and 3 (different roles) are different
Then verify that responses response2 and response3 are different

