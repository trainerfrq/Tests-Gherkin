Narrative:
As a an operator
I want to search the phone book for an empty search pattern
So that I can verify that all the phone book entries from the phone book will be returned

Meta:
	  @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
	  @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer

Scenario: Search telephone book with empty search pattern
		  @REQUIREMENTS:GID-2877942
When WS1 requests a number of 10 entries starting from index 0 with an empty search pattern and saves the requestId1

Scenario: Assert number of entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with a total number of 10 entries

Scenario: Assert that more items are available
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with more items available flag being true

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer
