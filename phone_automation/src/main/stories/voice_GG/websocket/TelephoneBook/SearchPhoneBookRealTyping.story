Narrative:
As a an operator
I want to search the phone book sending consecutively requests simulating the real typing of a search criteria
So that I can verify that in the final response the corresponding entries will be returned

Meta: @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
	  @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Define phone book entries
Given the following phone book entries:
| key    | uri                    | name              | full-name | location | organization | notes | display-addon | call-priority |
| entry1 | sip:police@78.56.43.21 | Police-Ambulance1 |           |          |              |       |               |   NON_URGENT  |
| entry2 | sip:police@99.56.34.21 | Police-Ambulance2 |           |          |              |       |               |   NON_URGENT  |
| entry3 | sip:police@12.34.56.78 | Police1           |           |          |              |       |               |   NON_URGENT  |
| entry4 | sip:police@12.34.56.89 | Police2           |           |          |              |       |               |   NON_URGENT  |
| entry5 | sip:police@78.65.43.21 | Police3           |           |          |              |       |               |   NON_URGENT  |

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer

Scenario: Search telephone book for p
When WS1 requests a number of 10 entries starting from index 0 with the search pattern p and saves the requestId1

Scenario: Search telephone book for po
When WS1 requests a number of 10 entries starting from index 0 with the search pattern po and saves the requestId2

Scenario: Search telephone book for pol
When WS1 requests a number of 10 entries starting from index 0 with the search pattern pol and saves the requestId3

Scenario: Search telephone book for poli
When WS1 requests a number of 10 entries starting from index 0 with the search pattern poli and saves the requestId4

Scenario: Search telephone book for polic
When WS1 requests a number of 10 entries starting from index 0 with the search pattern polic and saves the requestId5

Scenario: Search telephone book for police
When WS1 requests a number of 10 entries starting from index 0 with the search pattern police and saves the requestId6

Scenario: Search telephone book for police-
When WS1 requests a number of 10 entries starting from index 0 with the search pattern police- and saves the requestId7

Scenario: Search telephone book for police-a
When WS1 requests a number of 10 entries starting from index 0 with the search pattern police-a and saves the requestId8

Scenario: Assert entries
		  @REQUIREMENTS:GID-2877942
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId8 with a total number of 2 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId8 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId8 with entry number 2 matching phone book entry entry2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer
