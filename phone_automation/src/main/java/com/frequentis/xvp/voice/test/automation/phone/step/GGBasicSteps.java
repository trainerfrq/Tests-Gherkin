/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.voice.test.automation.phone.step;

import scripts.cats.websocket.sequential.SendTextMessage;
import scripts.cats.websocket.sequential.buffer.ReceiveAllReceivedMessages;
import scripts.cats.websocket.sequential.buffer.ReceiveLastReceivedMessage;
import scripts.cats.websocket.sequential.buffer.SendAndReceiveTextMessage;
import static com.frequentis.c4i.test.model.MatcherDetails.match;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.empty;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.instanceOf;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.not;
import static org.hamcrest.Matchers.notNullValue;
import static org.hamcrest.Matchers.nullValue;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;
import java.util.stream.Collectors;

import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.automation.model.ProfileToWebSocketConfigurationReference;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.tools.cats.websocket.dto.WebsocketAutomationSteps;
import com.frequentis.xvp.voice.opvoice.config.layout.JsonDaDataElement;
import com.frequentis.xvp.voice.opvoice.json.messages.AssociateResponse;
import com.frequentis.xvp.voice.opvoice.json.messages.AssociateResponseResult;
import com.frequentis.xvp.voice.opvoice.json.messages.CallAcceptRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.CallClearRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.CallEstablishRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.CallHoldRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.CallIncomingConfirmation;
import com.frequentis.xvp.voice.opvoice.json.messages.CallRetrieveRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.CallStatusIndication;
import com.frequentis.xvp.voice.opvoice.json.messages.DisassociateResponse;
import com.frequentis.xvp.voice.opvoice.json.messages.DisassociateResponseResult;
import com.frequentis.xvp.voice.opvoice.json.messages.JsonMessage;
import com.frequentis.xvp.voice.opvoice.json.messages.layout.QueryRolePhoneDataRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.missions.ChangeMissionRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.missions.ChangeMissionResponseResult;
import com.frequentis.xvp.voice.opvoice.json.messages.missions.MissionChangeCompletedEvent;
import com.frequentis.xvp.voice.opvoice.json.messages.missions.MissionChangedIndication;
import com.google.common.collect.Lists;

public class GGBasicSteps extends WebsocketAutomationSteps
{
   @When("$namedWebSocket associates with Op Voice Service using opId $opId and appId $appId")
   public void associateWithOpVoiceService( final String namedWebSocket, final String opId, final String appId )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request = JsonMessage.newAssociateRequest( UUID.randomUUID(), opId, appId );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Sending associate request for operator " + opId + " and appId " + appId )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "associateResponse" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received associate response" )
            .details( match( jsonMessage.body().getPayload(), instanceOf( AssociateResponse.class ) ) )
            .details( match( jsonMessage.body().associateResponse().result().resultCode(),
                  equalTo( AssociateResponseResult.ResultCode.OK ) ) )
            .details( match( jsonMessage.body().associateResponse().opId(), equalTo( opId ) ) )
            .details( match( jsonMessage.body().associateResponse().appId(), equalTo( appId ) ) ) );
   }


   @Then("$namedWebSocket receives missions available indication on message buffer named $bufferName and names the $availableMissionIdsName")
   public void receiveMissionsAvailableIndication( final String namedWebSocket, final String bufferName,
         final String availableMissionIdsName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate( remoteStep(
                  "Receiving the last message on websocket " + namedWebSocket + " for buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received missions available indication" )
            .details( match( jsonMessage.body().isMissionsAvailableIndication(), equalTo( true ) ) ) );

      final ArrayList<String> missionIds =
            Lists.newArrayList( jsonMessage.body().missionsAvailableIndication().getMissions().stream()
                  .map( mission -> mission.getMissionId() ).collect( Collectors.toList() ) );
      setStoryData( availableMissionIdsName, missionIds );
   }


   @Then("$namedWebSocket receives mission changed indication on message buffer named $bufferName and names $missionIdName")
   public void receiveMissionChangedIndication( final String namedWebSocket, final String bufferName,
         final String missionIdName )
   {
      final MissionChangedIndication missionChangedIndication =
            verifyMissionChangedIndicationReceived( namedWebSocket, bufferName );
      setStoryData( missionIdName, missionChangedIndication.getMissionId() );
   }


   @Then("$namedWebSocket receives mission changed indication on buffer named $bufferName equal to $missionIdToChangeName and names $missionIdName and $roleIdName")
   public void receiveMissionChangedIndicationAndVerifyMissionId( final String namedWebSocket, final String bufferName,
         final String missionIdToChangeName, final String missionIdName, final String roleIdName )
   {
      final MissionChangedIndication missionChangedIndication =
            verifyMissionChangedIndicationReceived( namedWebSocket, bufferName );

      evaluate( localStep( "Verify mission changed indication" )
            .details( match( "Mission id does not match", missionChangedIndication.getMissionId(),
                  equalTo( getStoryData( missionIdToChangeName, String.class ) ) ) )
            .details( match( "List of assigned roles is empty", missionChangedIndication.getAssignedRoles(),
                  not( empty() ) ) ) );

      setStoryData( missionIdName, missionChangedIndication.getMissionId() );
      setStoryData( roleIdName, missionChangedIndication.getAssignedRoles().stream()
            .map( roleElement -> roleElement.getRoleId() ).findFirst().get() );
   }


   @Then("$namedWebSocket confirms mission change completed for mission $missionIdName")
   public void sendMissionChangeCompletedEvent( final String namedWebSocket, final String missionIdName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      String missionId = getStoryData( missionIdName, String.class );

      final JsonMessage event =
            JsonMessage.newMissionChangeCompletedEvent( new MissionChangeCompletedEvent( missionId ),
                  UUID.randomUUID() );

      evaluate( remoteStep( "Sending mission change completed event for mission " + missionId )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendTextMessage.IPARAM_MESSAGETOSEND, event.toJson() ) );
   }


   @When("$namedWebSocket chooses mission with index $missionIndex from available missions named $availableMissionIdsName and names $missionIdToChangeName")
   public void changeMission( final String namedWebSocket, final int missionIndex, final String availableMissionIdsName,
         final String missionIdToChangeName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final ArrayList<String> availableMissionIds = getStoryData( availableMissionIdsName, ArrayList.class );

      evaluate( localStep( "Retrieving missionId from story data" )
            .details( ExecutionDetails.create( "Available missions contains given index" )
                  .usedData( "Available missions count", availableMissionIds.size() )
                  .usedData( "Given index", missionIndex ).success( availableMissionIds.size() > missionIndex ) ) );

      final String missionId = availableMissionIds.get( missionIndex );
      final JsonMessage request =
            JsonMessage.newChangeMissionRequest( new ChangeMissionRequest( missionId ), UUID.randomUUID() );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Changing mission to mission " + missionId )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "changeMissionResponse" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received change mission response" )
            .details(
                  match( "Is change mission response", jsonMessage.body().isChangeMissionResponse(), equalTo( true ) ) )
            .details(
                  match( "Response is successful", jsonMessage.body().changeMissionResponse().getResult().resultCode(),
                        equalTo( ChangeMissionResponseResult.ResultCode.OK ) ) ) );

      setStoryData( missionIdToChangeName, missionId );
   }


   @When("$namedWebSocket loads phone data for role $roleIdName and names $callSourceName and $callTargetName")
   public void loadPhoneData( final String namedWebSocket, final String roleIdName, final String callSourceName,
         final String callTargetName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final String roleId = getStoryData( roleIdName, String.class );
      QueryRolePhoneDataRequest queryRolePhoneDataRequest = new QueryRolePhoneDataRequest( roleId );
      final JsonMessage request =
            JsonMessage.builder().withQueryRolePhoneDataRequest( queryRolePhoneDataRequest )
                  .withCorrelationId( UUID.randomUUID() ).build();

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Querying role phone data for role " + roleId )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "queryRolePhoneDataResponse" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received query role phone data response" )
            .details( match( "Is query role phone data response", jsonMessage.body().isQueryRolePhoneDataResponse(),
                  equalTo( true ) ) )
            .details( match( "Response is successful", jsonMessage.body().queryRolePhoneDataResponse().getError(),
                  nullValue() ) )
            .details( match( "Phone data is not empty",
                  jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa(), not( empty() ) ) ) );

      final JsonDaDataElement dataElement =
            jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa().iterator().next();
      setStoryData( callSourceName, dataElement.getSource() );
      setStoryData( callTargetName, dataElement.getTarget() );
   }


   @When("$namedWebSocket establishes an outgoing phone call using source $callSourceName ang target $callTargetName and names $phoneCallIdName")
   public void establishOutgoingPhoneCall( final String namedWebSocket, final String callSourceName,
         final String callTargetName, final String phoneCallIdName )
   {
      establishOutgoingCall( namedWebSocket, callSourceName, callTargetName, phoneCallIdName, "DA/IDA" );
   }


   @When("$namedWebSocket establishes an outgoing IA call with source $callSourceName and target $callTargetName and names $phoneCallIdName")
   public void establishOutgoingIACall( final String namedWebSocket, final String callSourceName,
         final String callTargetName, final String phoneCallIdName )
   {
      establishOutgoingCall( namedWebSocket, callSourceName, callTargetName, phoneCallIdName, "IA" );
   }


   @Then("$namedWebSocket receives call status indication on message buffer named $bufferName with callId $phoneCallIdName and status $callStatus")
   public void receiveCallStatusIndication( final String namedWebSocket, final String bufferName,
         final String phoneCallIdName, final String callStatus )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving call status indication on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Verify call status indication" )
            .details(
                  match( "Is call status indication", jsonMessage.body().isCallStatusIndication(), equalTo( true ) ) )
            .details( match( "Phone call id matches", jsonMessage.body().callStatusIndication().getCallId(),
                  equalTo( getStoryData( phoneCallIdName, String.class ) ) ) )
            .details( match( "Call status does not match", jsonMessage.body().callStatusIndication().getCallStatus(),
                  equalTo( callStatus ) ) ) );
   }


   @Then("$namedWebSocket receives call status indication verifying all the messages on message buffer named $bufferName with callId $phoneCallIdName and status $callStatus")
   public void receiveCallStatusIndicationAllMessages( final String namedWebSocket, final String bufferName,
         final String phoneCallIdName, final String callStatus )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving all call status indication messages on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveAllReceivedMessages.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveAllReceivedMessages.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveAllReceivedMessages.IPARAM_BUFFERKEY, bufferName ) );

      final List<String> receivedMessagesList =
            ( List<String> ) remoteStepResult.getOutput( ReceiveAllReceivedMessages.OPARAM_RECEIVEDMESSAGES );

      final Optional<String> desiredMessage =
            receivedMessagesList.stream().map( JsonMessage::fromJson ).collect( Collectors.toList() ).stream()
                  .filter( jsonMessage -> jsonMessage.body().isCallStatusIndication() )
                  .filter( jsonMessage -> jsonMessage.body().callStatusIndication().getCallId()
                        .equals( getStoryData( phoneCallIdName, String.class ) ) )
                  .filter(
                        jsonMessage -> jsonMessage.body().callStatusIndication().getCallStatus().equals( callStatus ) )
                  .findFirst().map( JsonMessage::toString );

      evaluate( localStep( "Verify if desired message was contained in buffer" )
            .details( match( "Buffer should contain desired message", desiredMessage.isPresent(), equalTo( true ) ) )
            .details( ExecutionDetails.create( "Desired message" ).usedData( "The desired message is: ",
                  desiredMessage.orElse( "Message was not found!" ) ) ) );
   }


   @Then("$namedWebSocket does NOT receive call status indication verifying all the messages on message buffer named $bufferName with callId $phoneCallIdName and status $callStatus")
   public void doesNotReceiveCallStatusIndicationAllMessages( final String namedWebSocket, final String bufferName,
         final String phoneCallIdName, final String callStatus )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving all call status indication messages on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveAllReceivedMessages.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveAllReceivedMessages.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveAllReceivedMessages.IPARAM_BUFFERKEY, bufferName ) );

      final List<String> receivedMessagesList =
            ( List<String> ) remoteStepResult.getOutput( ReceiveAllReceivedMessages.OPARAM_RECEIVEDMESSAGES );

      final Optional<String> desiredMessage =
            receivedMessagesList.stream().map( JsonMessage::fromJson ).collect( Collectors.toList() ).stream()
                  .filter( jsonMessage -> jsonMessage.body().isCallStatusIndication() )
                  .filter( jsonMessage -> jsonMessage.body().callStatusIndication().getCallId()
                        .equals( getStoryData( phoneCallIdName, String.class ) ) )
                  .filter(
                        jsonMessage -> jsonMessage.body().callStatusIndication().getCallStatus().equals( callStatus ) )
                  .findFirst().map( JsonMessage::toString );

      evaluate( localStep( "Verify if desired message was contained in buffer" )
            .details( match( "Buffer should contain desired message", desiredMessage.isPresent(), equalTo( false ) ) )
            .details( ExecutionDetails.create( "Desired message" ).usedData( "The desired message is: ",
                  desiredMessage.orElse( "Message was not found!" ) ) ) );
   }


   @Then("$namedWebSocket receives call status indication on message buffer named $bufferName with callId $phoneCallIdName and status $callStatus and audio direction $audioDirection")
   public void receiveCallStatusIndicationOpt( final String namedWebSocket, final String bufferName,
         final String phoneCallIdName, final String callStatus, final String audioDirection )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving call status indication on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Verify call status indication" )
            .details(
                  match( "Is call status indication", jsonMessage.body().isCallStatusIndication(), equalTo( true ) ) )
            .details( match( "Phone call id matches", jsonMessage.body().callStatusIndication().getCallId(),
                  equalTo( getStoryData( phoneCallIdName, String.class ) ) ) )
            .details( match( "Call status does not match", jsonMessage.body().callStatusIndication().getCallStatus(),
                  equalTo( callStatus ) ) )
            .details( match( "Audio Direction does not match",
                  jsonMessage.body().callStatusIndication().getAudioDirection(), equalTo( audioDirection ) ) ) );
   }


   @Then("$namedWebSocket receives call status indication with $callStatus status on message buffer named $bufferName with callId $phoneCallIdName and terminationDetails $terminationDetails")
   public void receiveCallStatusIndicationTerminated( final String namedWebSocket, final String callStatus,
         final String bufferName, final String phoneCallIdName, final String terminationDetails )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving call status indication on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Verify call status indication" )
            .details(
                  match( "Is call status indication", jsonMessage.body().isCallStatusIndication(), equalTo( true ) ) )
            .details( match( "Phone call id matches", jsonMessage.body().callStatusIndication().getCallId(),
                  equalTo( getStoryData( phoneCallIdName, String.class ) ) ) )
            .details( match( "Call status matches", jsonMessage.body().callStatusIndication().getCallStatus(),
                  equalTo( callStatus ) ) )
            .details( match( "Termination details is not null",
                  jsonMessage.body().callStatusIndication().getTerminationDetails(), is( notNullValue() ) ) )
            .details( match( "Termination details cause is " + terminationDetails,
                  jsonMessage.body().callStatusIndication().getTerminationDetails().getCause(),
                  equalTo( terminationDetails ) ) )

      );
   }


   @When("$namedWebSocket receives call incoming indication for IA call on message buffer named $bufferName with $callSource and $callTarget and names $incomingPhoneCallId and audio direction $audioDirection")
   public void receiveCallIncomingIndicationType( final String namedWebSocket, final String bufferName,
         final String callSourceName, final String callTargetName, final String phoneCallIdName,
         final String audioDirection )
   {
      receiveCallIncomingIndication( namedWebSocket, bufferName, callSourceName, callTargetName, phoneCallIdName, "IA",
            audioDirection, CallStatusIndication.CONNECTED );
   }


   @When("$namedWebSocket receives call incoming indication on message buffer named $bufferName with $callSource and $callTarget and names $incomingPhoneCallId")
   public void receiveCallIncomingIndication( final String namedWebSocket, final String bufferName,
         final String callSourceName, final String callTargetName, final String phoneCallIdName )
   {
      receiveCallIncomingIndication( namedWebSocket, bufferName, callSourceName, callTargetName, phoneCallIdName,
            "DA/IDA", CallStatusIndication.INC_INITIATED );
   }


   @When("$namedWebSocket confirms incoming phone call with callId $phoneCallIdName")
   public void confirmsIncomingCall( final String namedWebSocket, final String phoneCallIdName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() )
                  .withPayload( new CallIncomingConfirmation( getStoryData( phoneCallIdName, String.class ) ) ).build();

      evaluate( remoteStep( "Confirming incoming phone call" )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );
   }


   @When("$namedWebSocket answers the incoming phone call with the callId $phoneCallIdName")
   public void answerIncomingPhoneCall( final String namedWebSocket, final String phoneCallIdName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() )
                  .withPayload( new CallAcceptRequest( getStoryData( phoneCallIdName, String.class ) ) ).build();
      evaluate( remoteStep( "Answering incoming phone call" )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );
   }


   @When("$namedWebSocket clears the phone call with the callId $phoneCallIdName")
   public void clearPhoneCall( final String namedWebSocket, final String phoneCallIdName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() )
                  .withPayload( new CallClearRequest( getStoryData( phoneCallIdName, String.class ) ) ).build();
      evaluate( remoteStep( "Clearing the phone call" )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );
   }


   @When("$namedWebSocket puts the phone call with the callId $phoneCallIdName on hold")
   public void holdPhoneCall( final String namedWebSocket, final String phoneCallIdName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() )
                  .withPayload( new CallHoldRequest( getStoryData( phoneCallIdName, String.class ) ) ).build();
      evaluate( remoteStep( "Holding the phone call" )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );
   }


   @When("$namedWebSocket retrieves the on hold phone call with the callId $phoneCallIdName")
   public void retrievePhoneCallOnHold( final String namedWebSocket, final String phoneCallIdName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() )
                  .withPayload( new CallRetrieveRequest( getStoryData( phoneCallIdName, String.class ) ) ).build();
      evaluate( remoteStep( "Holding the phone call" )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );
   }


   @When("$namedWebSocket disassociates from Op Voice Service")
   public void disassociateFromOpVoiceService( final String namedWebSocket )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request = JsonMessage.newDisassociateRequest();

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Sending disassociate request on websocket " + namedWebSocket )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "disassociateResponse" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received disassociate response" )
            .details( match( jsonMessage.body().getPayload(), instanceOf( DisassociateResponse.class ) ) )
            .details( match( jsonMessage.body().disassociateResponse().result().resultCode(),
                  equalTo( DisassociateResponseResult.ResultCode.OK ) ) ) );
   }


   private MissionChangedIndication verifyMissionChangedIndicationReceived( final String namedWebSocket,
         final String bufferName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving mission changed indication on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received mission changed indication" )
            .details( match( jsonMessage.body().isMissionChangedIndication(), equalTo( true ) ) ) );

      return jsonMessage.body().missionChangedIndication();
   }


   private void receiveCallIncomingIndication( final String namedWebSocket, final String bufferName,
         final String callSourceName, final String callTargetName, final String phoneCallIdName, final String callType,
         final String callState )
   {
      receiveCallIncomingIndication( namedWebSocket, bufferName, callSourceName, callTargetName, phoneCallIdName,
            callType, null, callState );
   }


   private void receiveCallIncomingIndication( final String namedWebSocket, final String bufferName,
         final String callSourceName, final String callTargetName, final String phoneCallIdName, final String callType,
         final Object audioDirection, final String callState )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving call incoming indication on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Verify call incoming indication" )
            .details( match( "Is call incoming indication", jsonMessage.body().isCallIncomingIndication(),
                  equalTo( true ) ) )
            .details( match( "Call status matches", jsonMessage.body().callIncomingIndication().getCallStatus(),
                  equalTo( callState ) ) )
            .details( match( "Call type matches", jsonMessage.body().callIncomingIndication().getCallType(),
                  equalTo( callType ) ) )
            .details( match( "Calling party matches",
                  jsonMessage.body().callIncomingIndication().getCallingParty().getUri(),
                  containsString( getStoryData( callSourceName, String.class ) ) ) )
            .details(
                  match( "Called party matches", jsonMessage.body().callIncomingIndication().getCalledParty().getUri(),
                        containsString( getStoryData( callTargetName, String.class ) ) ) )
            .details( match( "AudioDirection matches", jsonMessage.body().callIncomingIndication().getAudioDirection(),
                  equalTo( audioDirection ) ) ) );

      setStoryData( phoneCallIdName, jsonMessage.body().callIncomingIndication().getCallId() );
   }


   private void establishOutgoingCall( final String namedWebSocket, final String callSourceName,
         final String callTargetName, final String phoneCallIdName, final String callType )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final String callingParty = getStoryData( callSourceName, String.class );
      final String calledParty = getStoryData( callTargetName, String.class );

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() )
                  .withPayload(
                        new CallEstablishRequest( new Random().nextInt(), callingParty, calledParty, callType ) )
                  .build();

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Establishing outgoing phone call to " + calledParty )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "callEstablishResponse" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      assertThatCallEstablishResponseWasReceived( phoneCallIdName, jsonResponse );
   }


   private void assertThatCallEstablishResponseWasReceived( final String phoneCallIdName, final String jsonResponse )
   {
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received call establish response" )
            .details(
                  match( "Is call establish response", jsonMessage.body().isCallEstablishResponse(), equalTo( true ) ) )
            .details(
                  match( "Call status is out_initiating", jsonMessage.body().callEstablishResponse().getCallStatus(),
                        equalTo( CallStatusIndication.OUT_INITIATING ) ) ) );

      setStoryData( phoneCallIdName, jsonMessage.body().callEstablishResponse().getCallId() );
   }
}
