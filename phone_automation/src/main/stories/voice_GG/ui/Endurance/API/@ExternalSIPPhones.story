Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host       | identifier |
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>> | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created