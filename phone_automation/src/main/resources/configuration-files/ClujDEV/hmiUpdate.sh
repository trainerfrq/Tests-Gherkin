#!/bin/bash

SERVER1="CJ-GG-DEV-DOC-1"
SERVER2="CJ-GG-DEV-DOC-2"
SERVER3="CJ-GG-DEV-DOC-3"

MISSION1="CJ-GG-DEV-DOC-1"
MISSION2="CJ-GG-DEV-DOC-2"

CWP1="CJ-GG-DEV-CWP-1"
CWP2="CJ-GG-DEV-CWP-2"
CWP3="CJ-GG-DEV-CWP-3"

echo "restart services to update hmi, please be patient"
ssh $SERVER3 "docker stop op-voice-service-CJ-GG-DEV-CWP-1"
ssh $SERVER3 "docker stop op-voice-service-CJ-GG-DEV-CWP-2"
ssh $SERVER3 "docker stop op-voice-service-CJ-GG-DEV-CWP-3"

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

ssh $SERVER3 "docker start op-voice-service-CJ-GG-DEV-CWP-1"
ssh $SERVER3 "docker start op-voice-service-CJ-GG-DEV-CWP-2"
ssh $SERVER3 "docker start op-voice-service-CJ-GG-DEV-CWP-3"

echo "done!"
