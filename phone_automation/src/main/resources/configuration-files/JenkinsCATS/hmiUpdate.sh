#!/bin/bash

SERVER1="DOC-VST02-11"
SERVER2="DOC-VST02-12"
SERVER3="DOC-VST02-13"

MISSION1="DOC-VST02-11"
MISSION2="DOC-VST02-12"

CWP1="CWP-VST02-14"
CWP2="CWP-VST02-15"
CWP3="CWP-VST02-16"

echo "restart services to update hmi, please be patient"
ssh $SERVER3 "docker stop op-voice-service-CWP-VST02-14"
ssh $SERVER3 "docker stop op-voice-service-CWP-VST02-15"
ssh $SERVER3 "docker stop op-voice-service-CWP-VST02-16"

echo "all op voice services are stopped"
echo "restart mission services"

ssh $MISSION1 "docker stop mission-service-1"
ssh $MISSION2 "docker stop mission-service-2"
ssh $MISSION1 "docker start mission-service-1"
ssh $MISSION2 "docker start mission-service-2"

echo "mission services restart, now wait until op-shell has updated hmi version"
sleep 10
ssh $CWP1 "docker restart op-shell-service"
ssh $CWP2 "docker restart op-shell-service"
ssh $CWP3 "docker restart op-shell-service"

sleep 10
echo "restart op voice services"

ssh $SERVER3 "docker start op-voice-service-CWP-VST02-14"
ssh $SERVER3 "docker start op-voice-service-CWP-VST02-15"
ssh $SERVER3 "docker start op-voice-service-CWP-VST02-16"

echo "done!"
