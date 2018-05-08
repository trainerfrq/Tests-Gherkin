Scenario: Connect to hosts
Given SSH connections:
| name        | remote-address      | remotePort | username | password  |
| dockerHost1 | <<DOCKER_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2 | <<DOCKER_HOST2_IP>> | 22         | root     | !frqAdmin |
| dockerHost3 | <<DOCKER_HOST3_IP>> | 22         | root     | !frqAdmin |
| hmiHost1    | <<CLIENT1_IP>>      | 22         | root     | !frqAdmin |
| hmiHost2    | <<CLIENT2_IP>>      | 22         | root     | !frqAdmin |
| hmiHost3    | <<CLIENT3_IP>>      | 22         | root     | !frqAdmin |

Scenario: Save logs of op-voice services
When SSH host dockerHost1 executes FILE_LOG_NAME=${HOSTNAME,,}-$(date +"%Y%m%d_%H%M%S").log && mkdir -p /var/log/opvoice/ && docker logs op-voice01 > /var/log/opvoice/${FILE_LOG_NAME} && gzip /var/log/opvoice/${FILE_LOG_NAME}
When SSH host dockerHost2 executes FILE_LOG_NAME=${HOSTNAME,,}-$(date +"%Y%m%d_%H%M%S").log && mkdir -p /var/log/opvoice/ && docker logs op-voice02 > /var/log/opvoice/${FILE_LOG_NAME} && gzip /var/log/opvoice/${FILE_LOG_NAME}
When SSH host dockerHost3 executes FILE_LOG_NAME=${HOSTNAME,,}-$(date +"%Y%m%d_%H%M%S").log && mkdir -p /var/log/opvoice/ && docker logs op-voice03 > /var/log/opvoice/${FILE_LOG_NAME} && gzip /var/log/opvoice/${FILE_LOG_NAME}

Scenario: Save logs of voice-hmi services
When SSH host hmiHost1 executes FILE_LOG_NAME=${HOSTNAME,,}-$(date +"%Y%m%d_%H%M%S").log && mkdir -p /var/log/voice-hmi/ && docker logs voice-hmi03 > /var/log/voice-hmi/${FILE_LOG_NAME} && gzip /var/log/voice-hmi/${FILE_LOG_NAME}
When SSH host hmiHost2 executes FILE_LOG_NAME=${HOSTNAME,,}-$(date +"%Y%m%d_%H%M%S").log && mkdir -p /var/log/voice-hmi/ && docker logs voice-hmi04 > /var/log/voice-hmi/${FILE_LOG_NAME} && gzip /var/log/voice-hmi/${FILE_LOG_NAME}
When SSH host hmiHost3 executes FILE_LOG_NAME=${HOSTNAME,,}-$(date +"%Y%m%d_%H%M%S").log && mkdir -p /var/log/voice-hmi/ && docker logs voice-hmi05 > /var/log/voice-hmi/${FILE_LOG_NAME} && gzip /var/log/voice-hmi/${FILE_LOG_NAME}

