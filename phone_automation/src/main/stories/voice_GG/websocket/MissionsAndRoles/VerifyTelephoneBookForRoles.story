Narrative:
As a an operator
I want to verify the phone book using different roles
So that I can verify that each role shall have assigned all configured Telephone Book entries.

Meta:
	  @BeforeStory: ../includes/@PrepareThreeClientsWithMissions.story
	  @AfterStory: ../includes/@CleanupThreeClients.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer1

Scenario: WS1 equests all entries from telephone book
When WS1 requests all entries and saves the requestId1

Scenario: Receive the response
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer1 for request with requestId1 and saves the entry names in response1

Scenario: Create the message buffers
When WS2 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer2

Scenario: WS1 equests all entries from telephone book
When WS2 requests all entries and saves the requestId2

Scenario: Receive the response
Then WS2 receives phone book response on buffer named PhoneBookResponseBuffer2 for request with requestId2 and saves the entry names in response2

Scenario: Create the message buffers
When WS3 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer3

Scenario: WS1 equests all entries from telephone book
When WS3 requests all entries and saves the requestId3

Scenario: Receive the response
Then WS3 receives phone book response on buffer named PhoneBookResponseBuffer3 for request with requestId3 and saves the entry names in response3

Scenario: Assert that phone book lists for operators 1, 2  and 3 are equal
		  @REQUIREMENTS:GID-2398730
Then verify that responses response1 and response2 are equal
Then verify that responses response1 and response3 are equal

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer1
When the named websocket WS2 removes the message buffer named PhoneBookResponseBuffer2
When the named websocket WS3 removes the message buffer named PhoneBookResponseBuffer3
