Narrative:
As a an operator
I want to search the phone book twice with the same string but with other case of the letters
So that I can verify that the entries returned in both responses are the same and have the same ordering

Meta: @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
	  @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Define phone book entries
Given the following phone book entries:
| key    | uri                    | name    | full-name | location | organization | notes | display-addon | call-priority |
| entry1 | sip:police@12.34.56.78 | Police1 |           |          |              |       |               |   NON_URGENT  |
| entry2 | sip:police@12.34.56.89 | Police2 |           |          |              |       |               |   NON_URGENT  |

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer

Scenario: Search telephone book for first two entries
When WS1 requests a number of 2 entries starting from index 0 with the search pattern police1 and saves the requestId1

Scenario: Assert entries
		  @REQUIREMENTS:GID-2877942
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with a total number of 1 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with entry number 1 matching phone book entry entry1

Scenario: Search telephone book again for first two entries
When WS1 requests a number of 2 entries starting from index 0 with the search pattern POLICE1 and saves the requestId2

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with a total number of 1 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with entry number 1 matching phone book entry entry1

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer
