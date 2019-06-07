Narrative:
As a an operator
I want to search the phone book for an empty search pattern
So that I can verify that all the phone book entries from the phone book will be returned

Meta: @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
	  @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Define phone book entries
Given the following phone book entries:
| key     | uri                         | name              | full-name              | location                                 | organization          | notes                                                          | display-addon |
| entry1  | sip:group1@example.com      | Group 1           | A1Call Group 1         | XVP Lab                                  | FRQ XVP GG-Team       |                                                                |               |
| entry2  | <<OPVOICE3_PHONE_URI>>      | Lloyd             | 2Lloyd Ripley          | 123 6th St. Melbourne, FL 32904          | European Applications | Language - English                                             | Ground2Ground |
| entry3  | <<SIP_PHONE2>>              | Madoline          | 3Madoline Katharyn     | 71 Pilgrim Avenue Chevy Chase, MD 20815  | Chinese Metals        | Language - Chinese                                             | Air2Ground    |
| entry4  | <<OPVOICE1_PHONE_URI>>      | OP1 Physical      | 0Physical Identity OP1 | XVP Lab                                  | FRQ XVP GG-Team       | This is the physical identity of the first operating position  |               |
| entry5  | sip:222222@example.com      | OP2 Physical      | 1Physical Identity OP2 | XVP Lab                                  | FRQ XVP GG-Team       | This is the physical identity of the second operating position |               |
| entry6  | sip:111111@example.com      | Operator1         | A3Operator1            |                                          |                       |                                                                |               |
| entry7  | sip:op3@example.com         | Operator3         | A2Operator3            |                                          |                       |                                                                |               |
| entry8  | sip:police@78.56.43.21      | Police-Ambulance1 | 7Wien Police           | Hubatschstrasse 44, 8010 SCHAFTAL        | Vienna Police         | Language - German                                              | Autobahn      |
| entry9  | sip:police@99.56.34.21      | Police-Ambulance2 | 8Wien Police           | Lendplatz 80, 8967 HAUS                  | Vienna Police         | Language - German                                              | Local         |
| entry10 | sip:police@12.34.56.78      | Police1           | 4Wien Police           | Spiegelsberg 18, 4753 ALTMANNSDORF       | Vienna Police         | Language - German                                              | Local         |
| entry11 | sip:police@12.34.56.89      | Police2           | 5Wien Police           | Annenstrasse 2, 4972 GUNDERPOLLING       | Vienna Police         | Language - German                                              | Autobahn      |
| entry12 | sip:police@78.65.43.21      | Police3           | 6Wien Police           | Lerchenfelder Straße 19, 3195 LAHNSATTEL | Vienna Police         | Language - German                                              | Local         |
| entry13 | sip:role1@example.com       | Role1             | A4Role1                |                                          |                       |                                                                |               |
| entry14 | sip:role2@example.com       | Role2             | A7Role2                |                                          |                       |                                                                |               |
| entry15 | sip:role1alias1@example.com | Role1Alias1       | A5Role1Alias1          |                                          |                       |                                                                |               |
| entry16 | sip:role1alias2@example.com | Role1Alias2       | A6Role1Alias2          |                                          |                       |                                                                |               |
| entry17 | sip:role2alias1@example.com | Role2Alias1       | A8Role2Alias1          |                                          |                       |                                                                |               |
| entry18 | sip:role2alias2@example.com | Role2Alias2       | A9Role2Alias2          |                                          |                       |                                                                |               |
| entry19 | sip:gg-snom1@example.com    | Snom 370 (Carol)  | 9Snom 370 SIP Phone    | XVP Lab                                  | FRQ XVP GG-Team                                                                                        |

Scenario: Create the message buffers
When WS1 opens the message buffer for message type phoneBookResponse named PhoneBookResponseBuffer

Scenario: Request all entries from telephone book
When WS1 requests all entries and saves the requestId1

Scenario: Assert first 19 entries
		  @REQUIREMENTS:GID-2659402
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with one entry matching phone book entry <key>

Examples:
| key     |
| entry1  |
| entry2  |
| entry3  |
| entry4  |
| entry5  |
| entry6  |
| entry7  |
| entry8  |
| entry9  |
| entry10 |
| entry11 |
| entry12 |
| entry13 |
| entry14 |
| entry15 |
| entry16 |
| entry17 |
| entry18 |
| entry19 |

Scenario: Assert that no more items are available
Then WS1 receives phone book response on buffer named PhoneBookResponseBuffer for request with requestId1 with more items available flag being false

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named PhoneBookResponseBuffer
