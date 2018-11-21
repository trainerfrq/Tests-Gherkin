Narrative:
As a an operator
I want to search the phone book using different roles
So that I can verify that each role shall have assigned all configured Telephone Book entries.

Meta:
	  @BeforeStory: ../includes/@PrepareTwoClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupTwoClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer1

Scenario: Request all entries from telephone book
When WS1 requests all entries and saves the requestId1

Scenario: Assert that no more items are available
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer1 for request with requestId1 with more items available flag being false

Scenario: Create the message buffers
When WS2 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer2

Scenario: Request all entries from telephone book
When WS2 requests all entries and saves the requestId2

Scenario: Assert that no more items are available
Then WS2 receives phone book response on buffer named PhoneBookResponseBuffer2 for request with requestId2 with more items available flag being false

Scenario: Assert that requestId1, and requestId2 are equal
		  @REQUIREMENTS:GID-2398730
Then verify that requestId1 and requestId3 are equal

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer1
When the named websocket WS2 removes the message buffer named PhoneBookResponseBuffer2
