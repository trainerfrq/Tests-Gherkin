Narrative:
As a an operator
I want to search the phone book with the same string twice
So that I can verify that the entries returned in both responses are the same and have the same ordering

Meta:
     @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
     @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Define phone book entries
Given the following phone book entries:
| key    | uri                    | name    | full-name   | location                           | organization  | notes             | display-addon |
| entry1 | sip:police@12.34.56.78 | Police1 | Wien Police | Spiegelsberg 18, 4753 ALTMANNSDORF | Vienna Police | Language - German | Local         |
| entry2 | sip:police@12.34.56.89 | Police1 | Wien Police | Spiegelsberg 18, 4753 ALTMANNSDORF | Vienna Police | Language - German | Autobahn      |

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer

Scenario: Search telephone book for first two entries
When WS1 requests a number of 2 entries starting from index 0 with the search pattern police1 and saves the requestId1

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with a total number of 2 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with entry number 2 matching phone book entry entry2

Scenario: Search telephone book again for first two entries
When WS1 requests a number of 2 entries starting from index 0 with the search pattern police1 and saves the requestId2

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with a total number of 2 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with entry number 2 matching phone book entry entry2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer
