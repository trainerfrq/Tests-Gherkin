#!/bin/bash

SERVER1="doc-vst02-11"
SERVER2="doc-vst02-12"
SERVER3="doc-vst02-13"

MISSION1="doc-vst02-11"
MISSION2="doc-vst02-12"

CWP1="cwp-vst02-14"
CWP2="cwp-vst02-15"
CWP3="cwp-vst02-16"

echo "restart services to update hmi, please be patient"
ssh $SERVER1 "docker stop op-voice-service-cwp-vst02-14-1"
ssh $SERVER1 "docker stop op-voice-service-cwp-vst02-15-1"
ssh $SERVER1 "docker stop op-voice-service-cwp-vst02-16-1"
ssh $SERVER3 "docker stop op-voice-service-cwp-vst02-14-2"
ssh $SERVER3 "docker stop op-voice-service-cwp-vst02-15-2"
ssh $SERVER3 "docker stop op-voice-service-cwp-vst02-16-2"


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

ssh $SERVER1 "docker start op-voice-service-cwp-vst02-14-1"
ssh $SERVER1 "docker start op-voice-service-cwp-vst02-15-1"
ssh $SERVER1 "docker start op-voice-service-cwp-vst02-16-1"
ssh $SERVER3 "docker start op-voice-service-cwp-vst02-14-2"
ssh $SERVER3 "docker start op-voice-service-cwp-vst02-15-2"
ssh $SERVER3 "docker start op-voice-service-cwp-vst02-16-2"


echo "done!"
