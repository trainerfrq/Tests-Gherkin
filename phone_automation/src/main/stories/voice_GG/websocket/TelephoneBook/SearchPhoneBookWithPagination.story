Narrative:
As a an operator
I want to search the phone book for a pattern which matches several entries from the phone book spanning over more than one responses
So that I can verify that the entries are the ones which I expect

Meta:
     @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
     @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Define phone book entries
Given the following phone book entries:
| key    | uri                    | name              | full-name   | location                                 | organization  | notes             | display-addon |
| entry1 | sip:police@78.56.34.21 | Police-Ambulance1 | Wien Police | Hubatschstrasse 44, 8010 SCHAFTAL        | Vienna Police | Language - German | Autobahn      |
| entry2 | sip:police@78.56.43.21 | Police-Ambulance1 | Wien Police | Hubatschstrasse 44, 8010 SCHAFTAL        | Vienna Police | Language - German | Local         |
| entry3 | sip:police@99.56.34.21 | Police-Ambulance2 | Wien Police | Lendplatz 80, 8967 HAUS                  | Vienna Police | Language - German | Local         |
| entry4 | sip:police@12.34.56.78 | Police1           | Wien Police | Spiegelsberg 18, 4753 ALTMANNSDORF       | Vienna Police | Language - German | Local         |
| entry5 | sip:police@12.34.56.89 | Police1           | Wien Police | Spiegelsberg 18, 4753 ALTMANNSDORF       | Vienna Police | Language - German | Autobahn      |
| entry6 | sip:police@12.34.56.89 | Police2           | Wien Police | Annenstrasse 2, 4972 GUNDERPOLLING       | Vienna Police | Language - German | Local         |
| entry7 | sip:police@78.65.43.21 | Police3           | Wien Police | Lerchenfelder Straße 19, 3195 LAHNSATTEL | Vienna Police | Language - German | Local         |

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer

Scenario: Search telephone book for first two entries
When WS1 requests a number of 2 entries starting from index 0 with the search pattern police and saves the requestId1

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with a total number of 2 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with entry number 1 matching phone book entry entry1
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with entry number 2 matching phone book entry entry2

Scenario: Assert that more items are available
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with more items available flag being true

Scenario: Search telephone book for second two entries
When WS1 requests a number of 2 entries starting from index 2 with the search pattern police and saves the requestId2

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with a total number of 2 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with entry number 1 matching phone book entry entry3
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with entry number 2 matching phone book entry entry4

Scenario: Assert that more items are available
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId2 with more items available flag being true

Scenario: Search telephone book for last three entries
When WS1 requests a number of 3 entries starting from index 4 with the search pattern police and saves the requestId3

Scenario: Assert entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with a total number of 3 entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with entry number 1 matching phone book entry entry5
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with entry number 2 matching phone book entry entry6
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with entry number 3 matching phone book entry entry7

Scenario: Assert that more items are available
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId3 with more items available flag being false

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer