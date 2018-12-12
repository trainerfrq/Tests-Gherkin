#!/bin/bash

SERVER1="cj-gg-cat-doc-1"
SERVER2="cj-gg-cat-doc-2"
SERVER3="cj-gg-cat-doc-3"

MISSION1="cj-gg-cat-doc-1"
MISSION2="cj-gg-cat-doc-2"

CWP1="cj-gg-cat-cwp-1"
CWP2="cj-gg-cat-cwp-2"
CWP3="cj-gg-cat-cwp-3"

echo "restart services to update hmi, please be patient"
ssh $SERVER2 "docker stop op-voice-service-cj-gg-cat-cwp-1-1"
ssh $SERVER2 "docker stop op-voice-service-cj-gg-cat-cwp-2-1"
ssh $SERVER2 "docker stop op-voice-service-cj-gg-cat-cwp-3-1"
ssh $SERVER3 "docker stop op-voice-service-cj-gg-cat-cwp-1-2"
ssh $SERVER3 "docker stop op-voice-service-cj-gg-cat-cwp-2-2"
ssh $SERVER3 "docker stop op-voice-service-cj-gg-cat-cwp-3-2"


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

ssh $SERVER2 "docker start op-voice-service-cj-gg-cat-cwp-1-1"
ssh $SERVER2 "docker start op-voice-service-cj-gg-cat-cwp-2-1"
ssh $SERVER2 "docker start op-voice-service-cj-gg-cat-cwp-3-1"
ssh $SERVER3 "docker start op-voice-service-cj-gg-cat-cwp-1-2"
ssh $SERVER3 "docker start op-voice-service-cj-gg-cat-cwp-2-2"
ssh $SERVER3 "docker start op-voice-service-cj-gg-cat-cwp-3-2"


echo "done!"
