Scenario: Connect to hosts
Given SSH connections:
| name        | remote-address      | remotePort | username | password  |
| dockerHost1 | <<DOCKER_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2 | <<DOCKER_HOST2_IP>> | 22         | root     | !frqAdmin |

Scenario: Save logs
When SSH host dockerHost1 executes FILE_LOG_NAME=${HOSTNAME,,}-$(date +"%Y%m%d_%H%M%S").log && mkdir -p /var/log/opvoice/ && docker logs op-voice01 > /var/log/opvoice/${FILE_LOG_NAME} && gzip /var/log/opvoice/${FILE_LOG_NAME}
And SSH host dockerHost2 executes FILE_LOG_NAME=${HOSTNAME,,}-$(date +"%Y%m%d_%H%M%S").log && mkdir -p /var/log/opvoice/ && docker logs op-voice02 > /var/log/opvoice/${FILE_LOG_NAME} && gzip /var/log/opvoice/${FILE_LOG_NAME}

