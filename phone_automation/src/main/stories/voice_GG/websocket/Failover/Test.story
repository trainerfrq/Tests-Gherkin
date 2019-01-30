
Scenario: Booking profiles
Given booked profiles:
| profile   | group | host       |
| websocket | hmi   | <<CO3_IP>> |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-1 | <<OPVOICE1_WS.URI>> | 1000             |
| WS_Config-2 | <<OPVOICE3_WS.URI>> | 1000             |
| WS_Config-3 | <<OPVOICE2_WS.URI>> | 1000             |
| WS_Config-4 | <<OPVOICE4_WS.URI>> | 1000             |

Given it is known what op voice instances are Active, the websocket configuration is applied:
| key | profile-name | websocket-config-name |
| WS1 | WEBSOCKET 1  | WS_Config-1           |
| WS2 | WEBSOCKET 1  | WS_Config-1           |
| WS3 | WEBSOCKET 1  | WS_Config-1           |
| WS4 | WEBSOCKET 1  | WS_Config-1           |
