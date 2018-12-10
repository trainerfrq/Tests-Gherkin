Narrative:
As a an operator
I want to search the phone for a string with no matching entries
So that I can verify that no entries will be returned in the response

Meta:
     @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
     @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer

Scenario: Search telephone book for first two entries
		  @REQUIREMENTS:GID-2877942
When WS1 requests a number of 2 entries starting from index 0 with the search pattern anystring and saves the requestId1

Scenario: Assert there are no matching entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with a total number of 0 entries

Scenario: Assert that no more items are available
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with more items available flag being false

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer
