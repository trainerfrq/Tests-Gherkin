Narrative:
As a an operator
I want to search the phone sending consecutive requests continuously concatenating a character to the previous string
So that I can verify that each request is responded with the corresponding entries for the specified search criteria

Meta: @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
	  @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Define phone book entries
Given the following phone book entries:
| key    | uri                    | name              | full-name    | location                                 | organization  | notes             | display-addon |
| entry1 | sip:police@78.56.43.21 | Police-Ambulance1 | 7Wien Police | Hubatschstrasse 44, 8010 SCHAFTAL        | Vienna Police | Language - German | Autobahn      |
| entry2 | sip:police@99.56.34.21 | Police-Ambulance2 | 8Wien Police | Lendplatz 80, 8967 HAUS                  | Vienna Police | Language - German | Local         |
| entry3 | sip:police@12.34.56.78 | Police1           | 4Wien Police | Spiegelsberg 18, 4753 ALTMANNSDORF       | Vienna Police | Language - German | Local         |
| entry4 | sip:police@12.34.56.89 | Police2           | 5Wien Police | Annenstrasse 2, 4972 GUNDERPOLLING       | Vienna Police | Language - German | Autobahn      |
| entry5 | sip:police@78.65.43.21 | Police3           | 6Wien Police | Lerchenfelder Straße 19, 3195 LAHNSATTEL | Vienna Police | Language - German | Local         |

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer

Scenario: Search telephone book for p
When WS1 requests a number of 10 entries starting from index 0 with the search pattern p and saves the requestId1

Scenario: Assert entries
		  @REQUIREMENTS:GID-2877942
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with a total number of 5 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with entry number 2 matching phone book entry entry2
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with entry number 3 matching phone book entry entry3
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with entry number 4 matching phone book entry entry4
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with entry number 5 matching phone book entry entry5

Scenario: Search telephone book for po
When WS1 requests a number of 10 entries starting from index 0 with the search pattern po and saves the requestId2

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with a total number of 5 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with entry number 2 matching phone book entry entry2
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with entry number 3 matching phone book entry entry3
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with entry number 4 matching phone book entry entry4
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with entry number 5 matching phone book entry entry5

Scenario: Search telephone book for pol
When WS1 requests a number of 10 entries starting from index 0 with the search pattern pol and saves the requestId3

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with a total number of 5 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with entry number 2 matching phone book entry entry2
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with entry number 3 matching phone book entry entry3
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with entry number 4 matching phone book entry entry4
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with entry number 5 matching phone book entry entry5

Scenario: Search telephone book for poli
When WS1 requests a number of 10 entries starting from index 0 with the search pattern poli and saves the requestId4

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId4 with a total number of 5 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId4 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId4 with entry number 2 matching phone book entry entry2
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId4 with entry number 3 matching phone book entry entry3
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId4 with entry number 4 matching phone book entry entry4
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId4 with entry number 5 matching phone book entry entry5

Scenario: Search telephone book for polic
When WS1 requests a number of 10 entries starting from index 0 with the search pattern polic and saves the requestId5

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId5 with a total number of 5 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId5 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId5 with entry number 2 matching phone book entry entry2
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId5 with entry number 3 matching phone book entry entry3
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId5 with entry number 4 matching phone book entry entry4
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId5 with entry number 5 matching phone book entry entry5

Scenario: Search telephone book for police
When WS1 requests a number of 10 entries starting from index 0 with the search pattern police and saves the requestId6

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId6 with a total number of 5 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId6 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId6 with entry number 2 matching phone book entry entry2
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId6 with entry number 3 matching phone book entry entry3
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId6 with entry number 4 matching phone book entry entry4
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId6 with entry number 5 matching phone book entry entry5

Scenario: Search telephone book for police-
When WS1 requests a number of 10 entries starting from index 0 with the search pattern police- and saves the requestId7

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId7 with a total number of 2 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId7 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId7 with entry number 2 matching phone book entry entry2

Scenario: Search telephone book for police-a
When WS1 requests a number of 10 entries starting from index 0 with the search pattern police-a and saves the requestId8

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId8 with a total number of 2 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId8 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId8 with entry number 2 matching phone book entry entry2

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer
