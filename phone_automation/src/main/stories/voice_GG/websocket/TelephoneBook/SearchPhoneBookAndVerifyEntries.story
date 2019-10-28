Narrative:
As a an operator
I want to search the phone book for an empty search pattern
So that I can verify that all the phone book entries from the phone book will be returned

Meta: @BeforeStory: ../includes/@PrepareClientWithMissionAndSipPhone.story
	  @AfterStory: ../includes/@CleanupOneClientAndSipPhone.story

Scenario: Define phone book entries
Given the following phone book entries:
| key     | uri                         | name              | full-name | location | organization | notes | display-addon | call-priority |
| entry1  | <<OP1_URI>>                 | <<OP1_NAME>>      |           |          |              |       |               | NORMAL        |
| entry2  | <<OP2_URI>>                 | <<OP2_NAME>>      |           |          |              |       |               | NORMAL        |
| entry3  | <<OP3_URI>>                 | <<OP3_NAME>>      |           |          |              |       |               | NORMAL        |
| entry4  | sip:group1@example.com      | group1            |           |          |              |       |               | NORMAL        |
| entry5  | <<ALL_PHONES>>              | groupall          |           |          |              |       |               | NORMAL        |
| entry6  | <<OPVOICE3_PHONE_URI>>      | Lloyd             |           |          |              |       |               | NON_URGENT    |
| entry7  | <<ROLE1_URI>>               | <<ROLE_1_NAME>>   |           |          |              |       |               | NORMAL        |
| entry8  | <<ROLE2_URI>>               | <<ROLE_2_NAME>>   |           |          |              |       |               | NORMAL        |
| entry9  | <<SIP_PHONE2>>              | Madoline          |           |          |              |       |               | NON_URGENT    |
| entry10 | <<OPVOICE1_PHONE_URI>>      | OP1 Physical      |           |          |              |       |               | NON_URGENT    |
| entry11 | <<OPVOICE2_PHONE_URI>>      | OP2 Physical      |           |          |              |       |               | NON_URGENT    |
| entry12 | sip:operator1@example.com   | operator1         |           |          |              |       |               | NORMAL        |
| entry13 | sip:police@78.56.43.21      | Police-Ambulance1 |           |          |              |       |               | NON_URGENT    |
| entry14 | sip:police@99.56.34.21      | Police-Ambulance2 |           |          |              |       |               | NON_URGENT    |
| entry15 | sip:police@12.34.56.78      | Police1           |           |          |              |       |               | NON_URGENT    |
| entry16 | sip:police@12.34.56.89      | Police2           |           |          |              |       |               | NON_URGENT    |
| entry17 | sip:police@78.65.43.21      | Police3           |           |          |              |       |               | NON_URGENT    |
| entry18 | sip:role1@example.com       | role1             |           |          |              |       |               | NORMAL        |
| entry19 | sip:role1alias1@example.com | role1alias1       |           |          |              |       |               | NORMAL        |
| entry20 | sip:role1alias2@example.com | role1alias2       |           |          |              |       |               | NORMAL        |
| entry21 | sip:role2@example.com       | role2             |           |          |              |       |               | NORMAL        |
| entry22 | sip:role2alias1@example.com | role2alias1       |           |          |              |       |               | NORMAL        |
| entry23 | sip:role2alias2@example.com | role2alias2       |           |          |              |       |               | NORMAL        |
| entry24 | sip:role2alias2@example.com | role2alias2       |           |          |              |       |               | NORMAL        |
| entry25 | sip:gg-snom1@example.com    | Snom 370 (Carol)  |           |          |              |       |               | NON_URGENT    |

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
