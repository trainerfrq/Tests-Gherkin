Narrative:
As a an operator
I want to verify the phone book using different roles
So that I can verify that each role shall have assigned all configured Telephone Book entries.

Meta:
	  @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Request phone book for first operator
When WS1 requests the phone book entry names for role roleId1 and saves the response response1

Scenario: Request layout for second operator
When WS2 requests the phone book entry names for role roleId2 and saves the response response2

Scenario: Request layout for third operator
When WS3 requests the phone book entry names for role roleId1 and saves the response response3

Scenario: Assert that phone book lists for operators 1, 2  and 3 are equal
		  @REQUIREMENTS:GID-2398730
Then verify that responses response1 and response2 are equal
Then verify that responses response1 and response3 are equal
