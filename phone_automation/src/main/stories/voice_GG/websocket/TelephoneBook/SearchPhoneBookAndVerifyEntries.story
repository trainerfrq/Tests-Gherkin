Narrative:
As a an operator
I want to search the phone book for an empty search pattern
So that I can verify that all the phone book entries from the phone book will be returned

Meta: @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
	  @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Define phone book entries
Given the following phone book entries:
| key     | uri                              | name               | full-name | location | organization | notes | display-addon |
| entry1  | <<OP1_URI>>                      | <<OP1_NAME>>       |           |          |              |       |               |
| entry2  | <<OP2_URI>>                      | <<OP2_NAME>>       |           |          |              |       |               |
| entry3  | <<OP3_URI>>                      | <<OP3_NAME>>       |           |          |              |       |               |
| entry4  | sip:group1@example.com           | group1             |           |          |              |       |               |
| entry5  | <<ALL_PHONES>> | groupall           |           |          |              |       |               |
| entry6  | <<OPVOICE3_PHONE_URI>>           | Lloyd              |           |          |              |       |               |
| entry7  | <<MISSION1_URI>>                 | <<MISSION_1_NAME>> |           |          |              |       |               |
| entry8  | <<MISSION2_URI>>                 | <<MISSION_2_NAME>> |           |          |              |       |               |
| entry9  | <<SIP_PHONE2>>                   | Madoline           |           |          |              |       |               |
| entry10 | <<OPVOICE1_PHONE_URI>>           | OP1 Physical       |           |          |              |       |               |
| entry11 | <<OPVOICE2_PHONE_URI>>           | OP2 Physical       |           |          |              |       |               |
| entry12 | sip:operator1@example.com        | operator1          |           |          |              |       |               |
| entry13 | sip:police@78.56.43.21           | Police-Ambulance1  |           |          |              |       |               |
| entry14 | sip:police@99.56.34.21           | Police-Ambulance2  |           |          |              |       |               |
| entry15 | sip:police@12.34.56.78           | Police1            |           |          |              |       |               |
| entry16 | sip:police@12.34.56.89           | Police2            |           |          |              |       |               |
| entry17 | sip:police@78.65.43.21           | Police3            |           |          |              |       |               |
| entry18 | sip:role1@example.com            | role1              |           |          |              |       |               |
| entry19 | sip:role1alias1@example.com      | role1alias1        |           |          |              |       |               |
| entry20 | sip:role1alias2@example.com      | role1alias2        |           |          |              |       |               |
| entry21 | sip:role2@example.com            | role2              |           |          |              |       |               |
| entry22 | sip:role2alias1@example.com      | role2alias1        |           |          |              |       |               |
| entry23 | sip:role2alias2@example.com      | role2alias2        |           |          |              |       |               |
| entry24 | sip:role2alias2@example.com      | role2alias2        |           |          |              |       |               |
| entry25 | sip:gg-snom1@example.com         | Snom 370 (Carol)   |           |          |              |       |               |

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
