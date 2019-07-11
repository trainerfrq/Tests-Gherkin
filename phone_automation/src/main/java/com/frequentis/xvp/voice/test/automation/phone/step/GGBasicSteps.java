/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.automation.model.ProfileToWebSocketConfigurationReference;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.tools.cats.websocket.dto.WebsocketAutomationSteps;
import com.frequentis.xvp.voice.common.op.AppId;
import com.frequentis.xvp.voice.common.op.OpId;
import com.frequentis.xvp.voice.controlbase.CorrelationId;
import com.frequentis.xvp.voice.opvoice.config.layout.JsonDaDataElement;
import com.frequentis.xvp.voice.opvoice.config.layout.JsonWidgetElement;
import com.frequentis.xvp.voice.opvoice.json.messages.JsonMessage;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.common.AssociateResponse;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.common.AssociateResponseResult;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.common.ClientId;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.common.DisassociateResponse;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.common.DisassociateResponseResult;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.layout.QueryPhoneDataRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.layout.QueryWidgetLayoutRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.missions.ChangeMissionRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.missions.ChangeMissionResponseResult;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.missions.Mission;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.missions.MissionChangeCompletedEvent;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.missions.MissionChangedIndication;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallAcceptRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallClearRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallEstablishRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallForwardCancelRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallForwardRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallHoldRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallIncomingConfirmation;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallRetrieveRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallStatusIndication;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallTransferRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallTransferResponse;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.websocket.sequential.SendTextMessage;
import scripts.cats.websocket.sequential.buffer.ReceiveAllReceivedMessages;
import scripts.cats.websocket.sequential.buffer.ReceiveLastReceivedMessage;
import scripts.cats.websocket.sequential.buffer.ReceiveMessageCount;
import scripts.cats.websocket.sequential.buffer.SendAndReceiveTextMessage;
import static com.frequentis.c4i.test.model.MatcherDetails.match;
import static org.hamcrest.Matchers.anyOf;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.empty;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.instanceOf;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.not;
import static org.hamcrest.Matchers.notNullValue;
import static org.hamcrest.Matchers.nullValue;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;
import java.util.stream.Collectors;

public class GGBasicSteps extends WebsocketAutomationSteps
{

   @When("$namedWebSocket associates with Op Voice Service using opId $opId and appId $appId")
   public void associateWithOpVoiceService( final String namedWebSocket, final String opId, final String appId )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request =
            JsonMessage.newAssociateRequest( ClientId.fromId( UUID.randomUUID() ), OpId.create( opId ),
                  AppId.create( appId ) );

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
            .details( match( jsonMessage.body().associateResponse().opId(), equalTo( OpId.create( opId ) ) ) )
            .details( match( jsonMessage.body().associateResponse().appId(), equalTo( AppId.create( appId ) ) ) ) );
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

      final HashMap<String, String> missions = new HashMap<>();
      for ( Mission mission : jsonMessage.body().missionsAvailableIndication().getMissions() )
      {
         missions.put( mission.getMissionName(), mission.getMissionId().getId() );
      }

      setStoryListData( availableMissionIdsName, missions );
   }


   @Then("$namedWebSocket receives mission changed indication on message buffer named $bufferName and names $missionIdName")
   public void receiveMissionChangedIndication( final String namedWebSocket, final String bufferName,
         final String missionIdName )
   {
      final MissionChangedIndication missionChangedIndication =
            verifyMissionChangedIndicationReceived( namedWebSocket, bufferName );
      setStoryListData( missionIdName, missionChangedIndication.getMissionId().getId() );
   }


   @Then("$namedWebSocket receives mission changed indication on buffer named $bufferName equal to $missionIdToChangeName and names $missionIdName and $roleIdName")
   public void receiveMissionChangedIndicationAndVerifyMissionId( final String namedWebSocket, final String bufferName,
         final String missionIdToChangeName, final String missionIdName, final String roleIdName )
   {
      final MissionChangedIndication missionChangedIndication =
            verifyMissionChangedIndicationReceived( namedWebSocket, bufferName );

      evaluate( localStep( "Verify mission changed indication" )
            .details( match( "Mission id does not match", missionChangedIndication.getMissionId().getId(),
                  equalTo( getStoryListData( missionIdToChangeName, String.class ) ) ) )
            .details( match( "List of assigned roles is empty", missionChangedIndication.getMasterRoleId(),
                  not( empty() ) ) ) );

      setStoryListData( missionIdName, missionChangedIndication.getMissionId().getId() );
      setStoryListData( roleIdName, missionChangedIndication.getMasterRoleId() );
   }


   @Then("$namedWebSocket confirms mission change completed for mission $missionIdName")
   public void sendMissionChangeCompletedEvent( final String namedWebSocket, final String missionIdName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      String missionId = getStoryListData( missionIdName, String.class );

      final JsonMessage event =
            JsonMessage.newMissionChangeCompletedEvent( new MissionChangeCompletedEvent( missionId ),
                  CorrelationId.fromId( UUID.randomUUID() ) );

      evaluate( remoteStep( "Sending mission change completed event for mission " + missionId )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendTextMessage.IPARAM_MESSAGETOSEND, event.toJson() ) );
   }


   @When("$namedWebSocket chooses mission with name $missionName from available missions named $availableMissionsName and names $missionIdToChangeName")
   public void changeMission( final String namedWebSocket, final String missionName, final String availableMissionsName,
         final String missionIdToChangeName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final HashMap<String, String> availableMissions = getStoryListData( availableMissionsName, HashMap.class );

      evaluate( localStep( "Retrieving missions from story data" ).details( ExecutionDetails
            .create( "Available missions contains given mission name" )
            .usedData( "Available missions count", availableMissions.size() )
            .usedData( "Given mission name", missionName ).success( availableMissions.containsKey( missionName ) ) ) );

      final String missionId = availableMissions.get( missionName );
      final JsonMessage request =
            JsonMessage.newChangeMissionRequest( new ChangeMissionRequest( missionId ),
                  CorrelationId.fromId( UUID.randomUUID() ) );

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

      setStoryListData( missionIdToChangeName, missionId );
   }


   @When("$namedWebSocket loads phone data for mission $missionIdName and names $callSourceName and $callTargetName from the entry number $entryNumber")
   public void loadPhoneData( final String namedWebSocket, final String missionIdName, final String callSourceName,
   final String callTargetName, final Integer entryNumber )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final String missionId = getStoryListData( missionIdName, String.class );
      QueryPhoneDataRequest queryPhoneDataRequest = new QueryPhoneDataRequest( missionId );
      final JsonMessage request =
            JsonMessage.builder().withQueryPhoneDataRequest( queryPhoneDataRequest )
                  .withCorrelationId( UUID.randomUUID() ).build();

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Querying phone data for mission " + missionId )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "queryPhoneDataResponse" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received query phone data response" )
            .details( match( "Response is successful", jsonMessage.body().queryPhoneDataResponse().getError(),
                  nullValue() ) )
            .details( match( "Phone data is not empty",
                  jsonMessage.body().queryPhoneDataResponse().getPhoneData().getDa(), not( empty() ) ) )
            .details( match( "Entry of given number is present",
                  jsonMessage.body().queryPhoneDataResponse().getPhoneData().getDa().size(),
                  greaterThanOrEqualTo( entryNumber ) ) ) );

      final JsonDaDataElement dataElement =
            jsonMessage.body().queryPhoneDataResponse().getPhoneData().getDa().get( entryNumber - 1 );
      setStoryListData( callSourceName, dataElement.getSource() );
      setStoryListData( callTargetName, dataElement.getTarget() );
   }

    @When("$namedWebSocket loads phone data for mission $missionIdName and same names for $callSourceName and $callTargetName from the entry number $entryNumber")
    public void loadPhoneDataForSameSourceAndTarget( final String namedWebSocket, final String missionIdName, final String callSourceName,
                               final String callTargetName, final Integer entryNumber )
    {
        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

        final String missionId = getStoryListData( missionIdName, String.class );
        QueryPhoneDataRequest queryPhoneDataRequest = new QueryPhoneDataRequest( missionId );
        final JsonMessage request =
                JsonMessage.builder().withQueryPhoneDataRequest( queryPhoneDataRequest )
                           .withCorrelationId( UUID.randomUUID() ).build();

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep( "Querying phone data for mission " + missionId )
                                .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                                                                        BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                                .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                                .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "queryPhoneDataResponse" )
                                .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

        final String jsonResponse =
                ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
        final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

        evaluate( localStep( "Received query phone data response" )
                          .details( match( "Response is successful", jsonMessage.body().queryRolePhoneDataResponse().getError(),
                                           nullValue() ) )
                          .details( match( "Phone data is not empty",
                                           jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa(), not( empty() ) ) )
                          .details( match( "Entry of given number is present",
                                           jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa().size(),
                                           greaterThanOrEqualTo( entryNumber ) ) ) );

        final JsonDaDataElement dataElement =
                jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa().get( entryNumber - 1 );
        setStoryListData( callSourceName, dataElement.getSource() );
        setStoryListData( callTargetName, dataElement.getSource() );
    }


   @When("$namedWebSocket establishes an outgoing phone call using source $callSourceName ang target $callTargetName and names $phoneCallIdName")
   public void establishOutgoingPhoneCall( final String namedWebSocket, final String callSourceName,
         final String callTargetName, final String phoneCallIdName )
   {
      establishOutgoingCall( namedWebSocket, callSourceName, callTargetName, phoneCallIdName, "DA/IDA", "NON-URGENT",
            CallStatusIndication.OUT_INITIATING, null );
   }


   @When("$namedWebSocket establishes an outgoing phone call with call conditional flag $callConditionalFlag using source $callSourceName ang target $callTargetName and names $phoneCallIdName")
   public void establishOutgoingPhoneCallWithCallConditionalFlag( final String namedWebSocket,
         final String callConditionalFlag, final String callSourceName, final String callTargetName,
         final String phoneCallIdName )
   {
      establishOutgoingCall( namedWebSocket, callSourceName, callTargetName, phoneCallIdName, "DA/IDA", "NON-URGENT",
            CallStatusIndication.OUT_INITIATING, callConditionalFlag );
   }


   @When("$namedWebSocket establishes an outgoing priority phone call using source $callSourceName ang target $callTargetName and names $phoneCallIdName")
   public void establishOutgoingPriorityPhoneCall( final String namedWebSocket, final String callSourceName,
         final String callTargetName, final String phoneCallIdName )
   {
      establishOutgoingCall( namedWebSocket, callSourceName, callTargetName, phoneCallIdName, "DA/IDA", "URGENT",
            CallStatusIndication.OUT_INITIATING, null );
   }


   @When("$namedWebSocket establishes an outgoing IA call with source $callSourceName and target $callTargetName and names $phoneCallIdName")
   public void establishOutgoingIACall( final String namedWebSocket, final String callSourceName,
         final String callTargetName, final String phoneCallIdName )
   {
      establishOutgoingCall( namedWebSocket, callSourceName, callTargetName, phoneCallIdName, "IA", null,
            CallStatusIndication.OUT_INITIATING, null );
   }


   @When("$namedWebSocket sends a call forward request to another operator with $callTargetName")
   public void configureCallForward( final String namedWebSocket, final String callTargetName )
   {
      sendCallForwardRequest( namedWebSocket, callTargetName );
   }


   @Then("$namedWebSocket receives call status indication on message buffer named $bufferName with callId $phoneCallIdName and status $callStatus")
   public void receiveCallStatusIndication( final String namedWebSocket, final String bufferName,
         final String phoneCallIdName, final String callStatus )
   {
      receiveCallStatusIndication( namedWebSocket, bufferName, phoneCallIdName, callStatus, null );
   }


   @Then("$namedWebSocket receives call status indication with call conditional flag $callConditionalFlag on message buffer named $bufferName with callId $phoneCallIdName and status $callStatus")
   public void receiveCallStatusIndicationWithCallConditionalFlag( final String namedWebSocket,
         final String callConditionalFlag, final String bufferName, final String phoneCallIdName,
         final String callStatus )
   {
      receiveCallStatusIndication( namedWebSocket, bufferName, phoneCallIdName, callStatus, callConditionalFlag );
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
                        .equals( getStoryListData( phoneCallIdName, String.class ) ) )
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
                        .equals( getStoryListData( phoneCallIdName, String.class ) ) )
                  .filter(
                        jsonMessage -> jsonMessage.body().callStatusIndication().getCallStatus().equals( callStatus ) )
                  .findFirst().map( JsonMessage::toString );

      evaluate( localStep( "Verify if desired message was contained in buffer" )
            .details( match( "Buffer should contain desired message", desiredMessage.isPresent(), equalTo( false ) ) )
            .details( ExecutionDetails.create( "Desired message" ).usedData( "The desired message is: ",
                  desiredMessage.orElse( "Message was not found!" ) ) ) );
   }


   @Then("$namedWebSocket is receiving call status indication on message buffer named $bufferName with callId $phoneCallIdName and status $callStatus and audio direction $audioDirection")
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
                  equalTo( getStoryListData( phoneCallIdName, String.class ) ) ) )
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
                  equalTo( getStoryListData( phoneCallIdName, String.class ) ) ) )
            .details( match( "Call status matches", jsonMessage.body().callStatusIndication().getCallStatus(),
                  equalTo( callStatus ) ) )
            .details( match( "Termination details is not null",
                  jsonMessage.body().callStatusIndication().getTerminationDetails(), is( notNullValue() ) ) )
            .details( match( "Termination details cause is " + terminationDetails,
                  jsonMessage.body().callStatusIndication().getTerminationDetails().getCause(),
                  equalTo( terminationDetails ) ) )

      );
   }


   @Then("$namedWebSocket has on the message buffer named $bufferName a number of $messageCount messages")
   public void checkBufferCount( final String namedWebSocket, final String bufferName, final Integer messageCount )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      evaluate( remoteStep( "Receiving message count on buffer named " + bufferName )
            .scriptOn( profileScriptResolver().map( ReceiveMessageCount.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( ReceiveMessageCount.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( ReceiveMessageCount.IPARAM_BUFFERKEY, bufferName )
            .input( ReceiveMessageCount.IPARAM_MESSAGE_COUNT, messageCount ) );
   }


   @When("$namedWebSocket receives call incoming indication for IA call on message buffer named $bufferName with $callSource and $callTarget and names $incomingPhoneCallId and audio direction $audioDirection")
   public void receiveCallIncomingIndicationWithAudioDirection( final String namedWebSocket, final String bufferName,
         final String callSourceName, final String callTargetName, final String phoneCallIdName,
         final String audioDirection )
   {
      receiveCallIncomingIndication( namedWebSocket, bufferName, callSourceName, callTargetName, phoneCallIdName, "IA",
            audioDirection, CallStatusIndication.CONNECTED, "URGENT" );
   }


   @When("$namedWebSocket receives call incoming indication on message buffer named $bufferName with $callSource and $callTarget and names $incomingPhoneCallId")
   public void receiveCallIncomingIndication( final String namedWebSocket, final String bufferName,
         final String callSourceName, final String callTargetName, final String phoneCallIdName )
   {
      receiveCallIncomingIndication( namedWebSocket, bufferName, callSourceName, callTargetName, phoneCallIdName,
            "DA/IDA", null, CallStatusIndication.INC_INITIATED, "NON-URGENT" );
   }


   @When("$namedWebSocket receives $callStatus call incoming indication on message buffer named $bufferName with $callSource and $callTarget and names $incomingPhoneCallId")
   public void receiveConnectedCallIncomingIndication( final String namedWebSocket, final String callStatus,
         final String bufferName, final String callSourceName, final String callTargetName,
         final String phoneCallIdName )
   {
      receiveCallIncomingIndication( namedWebSocket, bufferName, callSourceName, callTargetName, phoneCallIdName,
            "DA/IDA", null, callStatus, "NON-URGENT" );
   }


   @When("$namedWebSocket receives an indication with $callStatus1 or $callStatus2 on message buffer named $bufferName with $callSource and $callTarget and names $incomingPhoneCallId")
   public void receiveConnectedCallIncomingIndications( final String namedWebSocket, final String callStatus1, final String callStatus2,
         final String bufferName, final String callSourceName, final String callTargetName,
         final String phoneCallIdName )
   {
      receiveTwoCallIncomingIndications( namedWebSocket, callStatus1, callStatus2, bufferName, callSourceName, callTargetName, phoneCallIdName,
            "DA/IDA", null, "NON-URGENT" );
   }


   @When("$namedWebSocket receives call incoming indication for priority call on message buffer named $bufferName with $callSource and $callTarget and names $incomingPhoneCallId")
   public void receiveCallIncomingIndicationForPriorityCall( final String namedWebSocket, final String bufferName,
         final String callSourceName, final String callTargetName, final String phoneCallIdName )
   {
      receiveCallIncomingIndication( namedWebSocket, bufferName, callSourceName, callTargetName, phoneCallIdName,
            "DA/IDA", null, CallStatusIndication.INC_INITIATED, "URGENT" );
   }


   @When("$namedWebSocket confirms incoming phone call with callId $phoneCallIdName")
   public void confirmsIncomingCall( final String namedWebSocket, final String phoneCallIdName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() )
                  .withPayload( new CallIncomingConfirmation( getStoryListData( phoneCallIdName, String.class ) ) ).build();

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
                  .withPayload( new CallAcceptRequest( getStoryListData( phoneCallIdName, String.class ) ) ).build();
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
                  .withPayload( new CallClearRequest( getStoryListData( phoneCallIdName, String.class ) ) ).build();
      evaluate( remoteStep( "Clearing the phone call" )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );
   }


   @When("$namedWebSocket puts the phone call with the callId $phoneCallIdName on hold")
   public void holdPhoneCall( final String namedWebSocket, final String phoneCallIdName )
   {
      putCallOnHold( namedWebSocket, phoneCallIdName, null );
   }


   @When("$namedWebSocket puts the phone call with the callId $phoneCallIdName on hold with call conditional flag $callConditionalFlag")
   public void holdPhoneCallWithCallConditionalFlag( final String namedWebSocket, final String phoneCallIdName,
         final String callConditionalFlag )
   {
      putCallOnHold( namedWebSocket, phoneCallIdName, callConditionalFlag );

   }


   @When("$namedWebSocket retrieves the on hold phone call with the callId $phoneCallIdName")
   public void retrievePhoneCallOnHold( final String namedWebSocket, final String phoneCallIdName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() )
                  .withPayload( new CallRetrieveRequest( getStoryListData( phoneCallIdName, String.class ) ) ).build();
      evaluate( remoteStep( "Holding the phone call" )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );
   }


   @When("$namedWebSocket is retrieving the on hold phone call with the callId $phoneCallIdName by establishing an outgoing phone call using source $callSource and target $callTarget")
   public void retrievePhoneCallOnHoldWithEstablish( final String namedWebSocket, final String phoneCallIdName,
         final String callSourceName, final String callTargetName )
   {
      establishOutgoingCall( namedWebSocket, callSourceName, callTargetName, phoneCallIdName, "DA/IDA", null,
            CallStatusIndication.HOLD, null );
   }


   @When("$namedWebSocket transfers the phone call with the transferee callId $transfereeCallIdName and transfer target callId $transferTargetCallIdName")
   public void transferPhoneCall( final String namedWebSocket, final String transfereeCallIdName,
         final String transferTargetCallIdName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final String transfereeCallId = getStoryListData( transfereeCallIdName, String.class );
      final String transferTargetCallId = getStoryListData( transferTargetCallIdName, String.class );

      final CallTransferRequest callTransferRequest =
            new CallTransferRequest( new Random().nextInt(), transfereeCallId, transferTargetCallId );

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() ).withPayload( callTransferRequest ).build();

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Transferring phone call" )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "callTransferResponse" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );

      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received call transfer response" )
            .details(
                  match( "Is call transfer response", jsonMessage.body().isCallTransferResponse(), equalTo( true ) ) )
            .details( match( "Result is successful", jsonMessage.body().callTransferResponse().getResult(),
                  equalTo( CallTransferResponse.Result.SUCCESSFUL.getValue() ) ) ) );
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


   @Then("verify that responses $requestId1 and $requestId2 are $equalOrDifferent")
   public void assertResponses( final String namedResponse1, final String namedResponse2, final String equalOrDifferent){
      String response1 = getStoryListData( namedResponse1, String.class );
      String response2 = getStoryListData( namedResponse2, String.class );
      switch ( equalOrDifferent ){
         case "equal":
            evaluate(localStep( "Verify request results are equal" ).details(
                  match( response1, equalTo( response2 ) ) ) );
            break;
         case "different":
            evaluate(localStep("Verify request results are different" ).details(
                  match( response1, not(equalTo( response2 ) ) ) ) );
            break;
      }
   }


   @When("$namedWebSocket requests the layout for mission $missionIdName and saves the response $responseIdName")
   public void sendAndReceiveRoleLayoutRequest( final String namedWebSocket, final String missionIdName, final String response )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final String missionId = getStoryListData( missionIdName, String.class );

      QueryWidgetLayoutRequest queryWidgetLayoutRequest = new QueryWidgetLayoutRequest( missionId );
      final JsonMessage request =
            JsonMessage.builder().withQueryWidgetLayoutRequest( queryWidgetLayoutRequest )
                  .withCorrelationId( UUID.randomUUID() ).build();

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Querying layout for mission " + missionId )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "queryWidgetLayoutResponse" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      List<String> layout = new ArrayList<>();
      for ( JsonWidgetElement jsonWidgetElement : jsonMessage.body().queryWidgetLayoutResponse().getWidgetLayout()
            .getWidgets() )
      {
         layout.add( jsonWidgetElement.getId() );
         layout.add( jsonWidgetElement.getGrid() );
         layout.add( jsonWidgetElement.getType().toString() );
      }
      setStoryListData( response, layout.toString());
   }


   @Then("$namedWebSocket receives a call forward status on message buffer named $bufferName with status $callForwardStatus")
   public void receiveCallForwardStatus( final String namedWebSocket, final String bufferName,
         final String callForwardStatus )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving call forward status on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( ReceiveLastReceivedMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Verify status in call forward status" )
            .details( match( "Is call forward status", jsonMessage.body().isCallForwardStatus(), equalTo( true ) ) )
            .details( match( "Call forward status " + callForwardStatus,
                  jsonMessage.body().callForwardStatus().getStatus(), equalTo( callForwardStatus ) ) ) );
   }


   @When("$namedWebSocket sends a call forward cancel request")
   public void sendCallForwardCancelRequest( final String namedWebSocket )
   {
      sendCallForwardCancel( namedWebSocket );
   }







   private void receiveTwoCallIncomingIndications( final String namedWebSocket, final String callStatus1, final String callStatus2, final String bufferName,
         final String callSourceName, final String callTargetName, final String phoneCallIdName, final String callType,
         final Object audioDirection, final String priority )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving call incoming indication on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Verify call incoming indication" )
            .details( match("Is call incoming indication", jsonMessage.body().isCallIncomingIndication(),
                  equalTo( true ) ) )
            .details( match( "Call status matches", jsonMessage.body().callIncomingIndication().getCallStatus(),
                  anyOf( equalTo( callStatus1 ), equalTo( callStatus2 ) ) ) )
            .details( match("Call type matches", jsonMessage.body().callIncomingIndication().getCallType(),
                  equalTo( callType )) )
            .details( match("Calling party matches",
                  jsonMessage.body().callIncomingIndication().getCallingParty().getUri(),
                  containsString( getStoryListData( callSourceName, String.class ) ) ) )
            .details(
                  match( "Called party matches", jsonMessage.body().callIncomingIndication().getCalledParty().getUri(),
                        containsString( getStoryListData( callTargetName, String.class ) ) ) )
            .details( match( "AudioDirection matches", jsonMessage.body().callIncomingIndication().getAudioDirection(),
                  equalTo( audioDirection ) ) )
            .details( match( "Call priority matches", jsonMessage.body().callIncomingIndication().getCallPriority(),
                  equalTo( priority ) ) ) );

      setStoryListData( phoneCallIdName, jsonMessage.body().callIncomingIndication().getCallId() );
   }


   private void receiveCallIncomingIndication( final String namedWebSocket, final String bufferName,
         final String callSourceName, final String callTargetName, final String phoneCallIdName, final String callType,
         final Object audioDirection, final String callStatus, final String priority )
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
                  equalTo( callStatus ) ) )
            .details( match( "Call type matches", jsonMessage.body().callIncomingIndication().getCallType(),
                  equalTo( callType ) ) )
            .details( match( "Calling party matches",
                  jsonMessage.body().callIncomingIndication().getCallingParty().getUri(),
                  containsString( getStoryListData( callSourceName, String.class ) ) ) )
            .details(
                  match( "Called party matches", jsonMessage.body().callIncomingIndication().getCalledParty().getUri(),
                        containsString( getStoryListData( callTargetName, String.class ) ) ) )
            .details( match( "AudioDirection matches", jsonMessage.body().callIncomingIndication().getAudioDirection(),
                  equalTo( audioDirection ) ) )
            .details( match( "Call priority matches", jsonMessage.body().callIncomingIndication().getCallPriority(),
                  equalTo( priority ) ) ) );

      setStoryListData( phoneCallIdName, jsonMessage.body().callIncomingIndication().getCallId() );
   }


   private void receiveCallStatusIndication( final String namedWebSocket, final String bufferName,
         final String phoneCallIdName, final String callStatus, final String callConditionalFlag )
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
                  equalTo( getStoryListData( phoneCallIdName, String.class ) ) ) )
            .details( match( "Call status does not match", jsonMessage.body().callStatusIndication().getCallStatus(),
                  equalTo( callStatus ) ) )
            .details( match( "Call conditional flag does not match",
                  jsonMessage.body().callStatusIndication().getCallConditionalFlag(),
                  equalTo( callConditionalFlag ) ) ) );
   }


   private void establishOutgoingCall( final String namedWebSocket, final String callSourceName,
         final String callTargetName, final String phoneCallIdName, final String callType, final String priority,
         final String callStatus, final String callConditionalFlag )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final String callingParty = getStoryListData( callSourceName, String.class );
      final String calledParty = getStoryListData( callTargetName, String.class );

      final CallEstablishRequest callEstablishRequest =
            CallEstablishRequest.builder( new Random().nextInt(), calledParty ).withCallType( callType )
                  .withCallingParty( callingParty ).withCallPriority( priority )
                  .withCallConditionalFlag( callConditionalFlag ).build();

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() ).withPayload( callEstablishRequest ).build();

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
      assertThatCallEstablishResponseWasReceived( phoneCallIdName, jsonResponse, callStatus );
   }


   private void putCallOnHold( final String namedWebSocket, final String phoneCallIdName,
         final String callConditionalFlag )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final CallHoldRequest.Builder builder = CallHoldRequest.builder( getStoryListData( phoneCallIdName, String.class ) );

      if ( callConditionalFlag != null )
      {
         builder.withCallConditionalFlag( callConditionalFlag );
      }

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() ).withPayload( builder.build() ).build();
      evaluate( remoteStep( "Holding the phone call" )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );
   }


   private void assertThatCallEstablishResponseWasReceived( final String phoneCallIdName, final String jsonResponse,
         final String callStatus )
   {
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received call establish response" )
            .details(
                  match( "Is call establish response", jsonMessage.body().isCallEstablishResponse(), equalTo( true ) ) )
            .details( match( "Call status is " + callStatus, jsonMessage.body().callEstablishResponse().getCallStatus(),
                  equalTo( callStatus ) ) ) );

      setStoryListData( phoneCallIdName, jsonMessage.body().callEstablishResponse().getCallId() );
   }


   private void sendCallForwardRequest( final String namedWebSocket, final String callTargetName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final String forwardParty = getStoryListData( callTargetName, String.class );

      final Integer transactionId = new Integer( 1234 );

      final CallForwardRequest callForwardRequest = new CallForwardRequest( transactionId, forwardParty );
      final JsonMessage request =
            new JsonMessage.Builder().withCorrelationId( UUID.randomUUID() ).withPayload( callForwardRequest ).build();

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Establishing call forward to " + forwardParty )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "callForwardConfirmation" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      assertThatCallForwardConfirmationWasReceived( transactionId, jsonResponse );
   }


   private void sendCallForwardCancel( final String namedWebSocket )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final Integer transactionId = new Integer( 1234 );
      final CallForwardCancelRequest callForwardCancelRequest = new CallForwardCancelRequest( transactionId );
      final JsonMessage request = new JsonMessage.Builder().withPayload( callForwardCancelRequest ).build();

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Establishing call forward cancel" )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "callForwardCancelConfirmation" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );

      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );
      evaluate( localStep( "Received call forward cancel confirmation response" )
            .details( match( "Is call forward cancel confirmation response ",
                  jsonMessage.body().isCallForwardCancelConfirmation(), equalTo( true ) ) ) );
   }


   private void assertThatCallForwardConfirmationWasReceived( final Integer transactionId, final String jsonResponse )
   {
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received call forward response" )
            .details( match( "Is call forward confirmation response", jsonMessage.body().isCallForwardConfirmation(),
                  equalTo( true ) ) )
            .details( match( "Transaction id is " + transactionId,
                  jsonMessage.body().callForwardConfirmation().getTransactionId(), equalTo( transactionId ) ) ) );
   }
}
