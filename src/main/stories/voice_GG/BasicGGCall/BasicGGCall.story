@REQUIREMENTS:GID-2535689

Scenario: Booking profiles
Given booked profiles:
| profile   | group  | host       |
| websocket | hmi    | <<CO1_IP>> |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri        | text-buffer-size |
| WS_Config-1 | <<OPVOICE1_WS.URI>>  | 1000             |
| WS_Config-2 | <<OPVOICE2_WS.URI>>  | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| key | profile-name | websocket-config-name |
| WS1 | WEBSOCKET 1  | WS_Config-1           |
| WS2 | WEBSOCKET 1  | WS_Config-2           |

Scenario: Associate with OPVoiceSvc1
Then start recording on named websocket WS1 with a buffer size of 1
When using the websocket WS1 the message named assocReq1 is sent as is with time stamp associateTime

Scenario: Associate with OPVoiceSvc2
Then start recording on named websocket WS2 with a buffer size of 1
When using the websocket WS2 the message named assocReq2 is sent as is with time stamp associateTime

Scenario:Send Establish Request
When using the websocket WS1 the message named callEstablishReq is sent as is with time stamp callEstablishTime
Then using the websocket WS1 websocket message is received and validated against the expected message callStatusInd and "callId": in the message saved as namedCallId

Scenario: Check incoming Request and accept call
Then using the websocket WS2 websocket message is received and validated against the expected message callIncomingInd and "callId": in the message saved as incomingCallId
Given the callAcceptReq is defined with variable incomingCallId as {"header":{"correlationId":"9c4fb267-e452-428f-b049-ae6709d659c8"},"body":{"callAcceptRequest":{"callId":incomingCallId}}}
When using the websocket WS2 the message named callAcceptReq is sent as is with time stamp callAcceptTime

Scenario: Clear call
Given the callClearReq is defined with variable namedCallId as {header: {correlationId: 0dac38fc-9d10-4def-ba0d-45d2c2dcb5bf},body: { callClearRequest: {callId:namedCallId}}}
When using the websocket WS1 the message named callClearReq is sent as is with time stamp callClearTime

Scenario: Cleanup
When using the websocket WS1 the message named disAssocReq is sent as is with time stamp disassociateTime
When using the websocket WS2 the message named disAssocReq is sent as is with time stamp disassociateTime
