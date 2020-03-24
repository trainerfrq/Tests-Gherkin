Scenario: Create sip phone
Given SipContacts group SipContact:
| key     | profile | user-entity | sip-uri        |
| Callee1 | VOIP    | 12345       | <<SIP_PHONE2>> |
| Callee2 | VOIP    | 946416      | <<SIP_PHONE5>> |
And phones for SipContact are created