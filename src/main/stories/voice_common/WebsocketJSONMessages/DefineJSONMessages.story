Meta:

Narrative:
As a user
I want to perform an action
So that I can achieve a business goal

Scenario: Define Common JSON messages
Given The assocReq is defined as {"header": { "correlationId": "b204f5dd-7913-4347-aa21-5affef710869"},"body": {"associateRequest": {"clientId": "7c5903b0-70ae-4318-851e-253b81418b5f","opId" : "m1", "appId" : "app1","version": {"major": 0,"minor": 1}}}}
And The assocResp is defined as "body": {"associateResponse": {
And The disAssocReq is defined as {header: {correlationId: 0cac38fc-9d10-4def-ba0d-45d2c2dcb5bf},body: { disassociateRequest: {}}}

Scenario: PHONE MESSAGES
Given The callEstablishReq is defined as {header: {correlationId: 1cac38fc-9d10-4def-ba0d-45d2c2dcb5bf},body: { callEstablishRequest: {transactionId:0, calledParty:"<<OPVOICE2_PHONE_URI>>"}}}
And The callEstablishPrioReq is defined as {header: {correlationId: 1cac38fc-9d10-4def-ba0d-45d2c2dcb5bf},body: { callEstablishRequest: {transactionId:0, callPriority:"EMERGENCY", calledParty:"<<OPVOICE2_PHONE_URI>>"}}}
And The callEstablishResp is defined as  "body": {"callEstablishResponse": {
And The callIncomingInd is defined as "body": {"callIncomingIndication": {
And The callStatusInd is defined as "body":{"callStatusIndication":{

Scenario: RADIO MESSAGES
Given The RxTxKeyinReq is defined as {"header": {"correlationId": "33dc9e34-5790-4880-a010-ef55a5204a1f"},"body": {"frequencyKeyInCommand": {"frequencyId":"<<BASIC_CALL_FID>>", "command": "RxTx"}}}
And The keyoutReq is defined as {"header": {"correlationId": "44dc9e34-5790-4880-a010-ef55a5204a1f"},"body": {"frequencyKeyInCommand": {"frequencyId":"<<BASIC_CALL_FID>>", "command": "Off"}}}
And The RxTxAck is defined as "body":{"frequencyStatus":{"frequencyId":"<<BASIC_CALL_FID>>","dialupState":"Established","stateRx":{"errorState":"NoError"},"stateTx":{"errorState":"NoError"},"couplingState":"Off","channels":[{"channelId":0,"channelKeyInType":"RxTx","stateRx":{"dialupState":"Off","errorState":"NoError"},"stateTx":{"dialupState":"Off","errorState":"NoError"}}]}}
And The ByeAck is defined as "body":{"frequencyStatus":{"frequencyId":"<<BASIC_CALL_FID>>","dialupState":"Off","stateRx":{"errorState":"NoError"},"stateTx":{"errorState":"NoError"},"couplingState":"Off","channels":[{"channelId":0,"channelKeyInType":"RxTx","stateRx":{"dialupState":"Off","errorState":"NoError"},"stateTx":{"dialupState":"Off","errorState":"NoError"}}]}}
