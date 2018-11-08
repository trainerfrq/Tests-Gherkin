Narrative:
As a an operator
I want to search the phone book for an empty search pattern
So that I can verify that all the phone book entries from the phone book will be returned

Meta:
	  @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
	  @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Define phone book entries
Given the following phone book entries:
| key     | uri                            | name              | full-name             | location                                 | organization          | notes                                                         | display-addon |
| entry1  | sip:group1@example.com         | Group 1           | Call Group 1          | XVP Lab                                  | FRQ XVP GG-Team       |                                                               |               |
| entry2  | <<OPVOICE3_PHONE_URI>>         | Lloyd             | Lloyd Ripley          | 123 6th St. Melbourne, FL 32904          | European Applications | Language - English                                            | Ground2Ground |
| entry3  | <<SIP_PHONE2>>                 | Madoline          | Madoline Katharyn     | 71 Pilgrim Avenue Chevy Chase, MD 20815  | Chinese Metals        | Language - Chinese                                            | Air2Ground    |
| entry4  | <<OPVOICE1_PHONE_URI>>         | OP1 Physical      | Physical Identity OP1 | XVP Lab                                  | FRQ XVP GG-Team       | This is the physical identity of the first operating position |               |
| entry5  | sip:222222@example.com         | OP2 Physical      | Physical Identity OP2 | XVP Lab                                  | FRQ XVP GG-Team       | This is the physical identity of the second operating position|               |
| entry6  | sip:police@78.56.34.21         | Police-Ambulance1 | Wien Police           | Hubatschstrasse 44, 8010 SCHAFTAL        | Vienna Police         | Language - German                                             | Autobahn      |
| entry7  | sip:police@78.56.43.21         | Police-Ambulance1 | Wien Police           | Hubatschstrasse 44, 8010 SCHAFTAL        | Vienna Police         | Language - German                                             | Local         |
| entry8  | sip:police@99.56.34.21         | Police-Ambulance2 | Wien Police           | Lendplatz 80, 8967 HAUS                  | Vienna Police         | Language - German                                             | Local         |
| entry9  | sip:police@12.34.56.78         | Police1           | Wien Police           | Spiegelsberg 18, 4753 ALTMANNSDORF       | Vienna Police         | Language - German                                             | Local         |
| entry10 | sip:police@12.34.56.89         | Police1           | Wien Police           | Spiegelsberg 18, 4753 ALTMANNSDORF       | Vienna Police         | Language - German                                             | Autobahn      |
| entry11 | sip:police@12.34.56.89         | Police2           | Wien Police           | Annenstrasse 2, 4972 GUNDERPOLLING       | Vienna Police         | Language - German                                             | Local         |
| entry12 | sip:police@78.65.43.21         | Police3           | Wien Police           | Lerchenfelder Straße 19, 3195 LAHNSATTEL | Vienna Police         | Language - German                                             | Local         |
| entry13 | sip:role1@example.com          | Role 1 (Alice)    | Role 1 - Alice        | XVP Lab                                  | FRQ XVP GG-Team       |                                                               |               |
| entry14 | sip:role1alias1@example.com    | Role 1 (Alice)    | Role 1 - Alice        | XVP Lab                                  | FRQ XVP GG-Team       |                                                               |               |
| entry15 | sip:role1alias2@example.com    | Role 1 (Alice)    | Role 1 - Alice        | XVP Lab                                  | FRQ XVP GG-Team       |                                                               |               |
| entry16 | sip:role2@example.com          | Role 2 (Bob)      | Role 2 - Bob          | XVP Lab                                  | FRQ XVP GG-Team       |                                                               |               |
| entry17 | sip:role2alias1@example.com    | Role 2 (Bob)      | Role 2 - Bob          | XVP Lab                                  | FRQ XVP GG-Team       |                                                               |               |
| entry18 | sip:role2alias2@example.com    | Role 2 (Bob)      | Role 2 - Bob          | XVP Lab                                  | FRQ XVP GG-Team       |                                                               |               |
| entry19 | sip:gg-snom1@<<DEP_SERVER_IP>> | Snom 370 (Carol)  | Snom 370 SIP Phone    | XVP Lab                                  | FRQ XVP GG-Team       |                                                               |               |
| entry20 | sip:gg-snom1@example.com       | Snom 370 (Carol)  | Snom 370 SIP Phone    | XVP Lab                                  | FRQ XVP GG-Team       |

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer

Scenario: Search telephone book with empty search pattern
When WS1 requests a number of 10 entries starting from index 0 with an empty search pattern and saves the requestId1

Scenario: Assert number of entries
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with a total number of 10 entries

Scenario: Assert that more items are available
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with more items available flag being true

Scenario: Request all entries from telephone book
When WS1 requests all entries and saves the requestId1

Scenario: Assert first 20 entries
		  @REQUIREMENTS:GID-2659402
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with one entry matching phone book entry <key>

Examples:
| key      |
| entry1   |
| entry2   |
| entry3   |
| entry4   |
| entry5   |
| entry6   |
| entry7   |
| entry8   |
| entry9   |
| entry10  |
| entry11  |
| entry12  |
| entry13  |
| entry14  |
| entry15  |
| entry16  |
| entry17  |
| entry18  |
| entry19  |
| entry20  |

Scenario: Assert that no more items are available
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with more items available flag being false

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer
