Scenario: Cleanup
When WS1 disassociates from Op Voice Service
When WS2 disassociates from Op Voice Service

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection
When WS2 closes websocket client connection

Scenario: Remove sip phone
When SipContact is removed
