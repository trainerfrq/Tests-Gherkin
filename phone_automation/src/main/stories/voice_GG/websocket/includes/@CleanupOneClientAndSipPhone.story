Scenario: Cleanup
When WS1 disassociates from Op Voice Service

Scenario: Remove sip phone
When SipContact is removed

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection
