Scenario: Booking steps
Given booked profiles:
|profile  | group  |host            |Identifier|
|voip/grs | grs    | <<CO1_IP>>     |GRS       |

Scenario: VoIP Prerequisites
Given SipContacts group GRS1:
| key | profile  | user-entity                |
| GRS | voip grs | <<BASIC_CALL_GRS.SIP.URI>> |

Given phone GRS1 is created
Given GRS1 automatically answers incoming calls
