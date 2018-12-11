/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.voice.test.automation.phone.step;

import scripts.cats.websocket.sequential.SendTextMessage;
import scripts.cats.websocket.sequential.buffer.ReceiveAllReceivedMessages;
import scripts.cats.websocket.sequential.buffer.ReceiveLastReceivedMessage;
import scripts.cats.websocket.sequential.buffer.ReceiveMessageCount;
import scripts.cats.websocket.sequential.buffer.SendAndReceiveTextMessage;
import static com.frequentis.c4i.test.model.MatcherDetails.match;
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

import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.automation.model.PhoneBookEntry;
import com.frequentis.xvp.tools.cats.websocket.automation.model.ProfileToWebSocketConfigurationReference;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.tools.cats.websocket.dto.WebsocketAutomationSteps;
import com.frequentis.xvp.voice.opvoice.config.common.AppId;
import com.frequentis.xvp.voice.opvoice.config.common.OpId;
import com.frequentis.xvp.voice.opvoice.config.layout.JsonDaDataElement;
import com.frequentis.xvp.voice.opvoice.config.layout.JsonWidgetElement;
import com.frequentis.xvp.voice.opvoice.json.messages.JsonMessage;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.common.AssociateResponse;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.common.AssociateResponseResult;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.common.DisassociateResponse;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.common.DisassociateResponseResult;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.layout.QueryRolePhoneDataRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.layout.QueryRoleWidgetLayoutRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.missions.ChangeMissionRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.missions.ChangeMissionResponseResult;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.missions.Mission;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.missions.MissionChangeCompletedEvent;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.missions.MissionChangedIndication;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallAcceptRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallClearRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallEstablishRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallHoldRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallIncomingConfirmation;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallRetrieveRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallStatusIndication;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallTransferRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.CallTransferResponse;

public class GGBasicSteps extends WebsocketAutomationSteps
{

   @When("$namedWebSocket associates with Op Voice Service using opId $opId and appId $appId")
   public void associateWithOpVoiceService( final String namedWebSocket, final String opId, final String appId )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final JsonMessage request =
            JsonMessage.newAssociateRequest( UUID.randomUUID(), OpId.create( opId ), AppId.create( appId ) );

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
         missions.put( mission.getMissionName(), mission.getMissionId() );
      }

      setStoryData( availableMissionIdsName, missions );
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


   @When("$namedWebSocket chooses mission with name $missionName from available missions named $availableMissionsName and names $missionIdToChangeName")
   public void changeMission( final String namedWebSocket, final String missionName, final String availableMissionsName,
         final String missionIdToChangeName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final HashMap<String, String> availableMissions = getStoryData( availableMissionsName, HashMap.class );

      evaluate( localStep( "Retrieving missions from story data" ).details( ExecutionDetails
            .create( "Available missions contains given mission name" )
            .usedData( "Available missions count", availableMissions.size() )
            .usedData( "Given mission name", missionName ).success( availableMissions.containsKey( missionName ) ) ) );

      final String missionId = availableMissions.get( missionName );
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


   @When("$namedWebSocket loads phone data for role $roleIdName and names $callSourceName and $callTargetName from the entry number $entryNumber")
   public void loadPhoneData( final String namedWebSocket, final String roleIdName, final String callSourceName,
   final String callTargetName, final Integer entryNumber )
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
                  jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa(), not( empty() ) ) )
            .details( match( "Entry of given number is present",
                  jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa().size(),
                  greaterThanOrEqualTo( entryNumber ) ) ) );

      final JsonDaDataElement dataElement =
            jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa().get( entryNumber - 1 );
      setStoryData( callSourceName, dataElement.getSource() );
      setStoryData( callTargetName, dataElement.getTarget() );
   }

    @When("$namedWebSocket loads phone data for role $roleIdName and same names for $callSourceName and $callTargetName from the entry number $entryNumber")
    public void loadPhoneDataForSameSourceAndTarget( final String namedWebSocket, final String roleIdName, final String callSourceName,
                               final String callTargetName, final Integer entryNumber )
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
                                           jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa(), not( empty() ) ) )
                          .details( match( "Entry of given number is present",
                                           jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa().size(),
                                           greaterThanOrEqualTo( entryNumber ) ) ) );

        final JsonDaDataElement dataElement =
                jsonMessage.body().queryRolePhoneDataResponse().getPhoneData().getDa().get( entryNumber - 1 );
        setStoryData( callSourceName, dataElement.getSource() );
        setStoryData( callTargetName, dataElement.getSource() );
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
                  .withPayload( new CallRetrieveRequest( getStoryData( phoneCallIdName, String.class ) ) ).build();
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

      final String transfereeCallId = getStoryData( transfereeCallIdName, String.class );
      final String transferTargetCallId = getStoryData( transferTargetCallIdName, String.class );

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


   @When("$namedWebSocket receives call incoming indication on message buffer named $bufferName with $callPartyType matching phone book entry $phoneBookEntry")
   public void receiveCallIncomingIndicationMatchingCallParty( final String namedWebSocket, final String bufferName,
         final String callPartyType, final String namedPhoneBookEntry )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving call incoming indication on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName )
                        .input( ReceiveLastReceivedMessage.IPARAM_DISCARDALLMESSAGES, false ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      PhoneBookEntry phoneBookEntry = getStoryListData( namedPhoneBookEntry, PhoneBookEntry.class );
      evaluate( localStep( "Check phone book entry" ).details(
            ExecutionDetails.create( "Verify phone book entry is defined" ).success( phoneBookEntry != null ) ) );

      switch ( callPartyType )
      {
         case "calledParty":
            assertCalledParty( jsonMessage, phoneBookEntry );
            break;
         case "callingParty":
            assertCallingParty( jsonMessage, phoneBookEntry );
            break;
         default:
            evaluate( localStep( "Check call party type" )
                  .details( ExecutionDetails.create( "Unknown call party type: " + callPartyType ).failure() ) );
            break;
      }
   }

   @When("$namedWebSocket requests the layout for role $roleIdName and saves the request $requestIdName")
   public void sendRoleLayoutRequest( final String namedWebSocket, final String roleIdName,
         final String namedRequestId  )
   {
      sendAndReceiveRoleLayoutRequest( namedWebSocket, roleIdName, namedRequestId );
   }

   @Then("verify that $requestId1 and $requestId2 are equal")
   public void assertEqualRequests( final String namedResponse1, final String namedResponse2 ){
      String response1 = getStoryListData( namedResponse1, String.class );
      String response2 = getStoryListData( namedResponse2, String.class );
      evaluate(localStep( "Verify request results are equal" ).details(
            match( response1, equalTo( response2 ) ) ) );
   }

   @Then("verify that $requestId1 and $requestId2 are different")
   public void assertDifferentRequests( final String namedResponse1, final String namedResponse2 ){
      String response1 = getStoryListData( namedResponse1, String.class );
      String response2 = getStoryListData( namedResponse2, String.class );
      evaluate(localStep("Verify request results are different" ).details(
            match( response1, not(equalTo( response2 ) ) ) ) );
   }

   private void sendAndReceiveRoleLayoutRequest( final String namedWebSocket, final String roleIdName, final String namedRequestId )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final String roleId = getStoryData( roleIdName, String.class );

      QueryRoleWidgetLayoutRequest queryRoleWidgetLayoutRequest = new QueryRoleWidgetLayoutRequest( roleId );
      final JsonMessage request =
            JsonMessage.builder().withQueryRoleWidgetLayoutRequest( queryRoleWidgetLayoutRequest )
                  .withCorrelationId( UUID.randomUUID() ).build();

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Querying role layout for role " + roleId )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "queryRoleWidgetLayoutResponse" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      List<String> layout = new ArrayList<>(  );
      for( JsonWidgetElement jsonWidgetElement : jsonMessage.body().queryRoleWidgetLayoutResponse().getWidgetLayout().getWidgets() )
      {
         layout.add( jsonWidgetElement.getId() );
         layout.add( jsonWidgetElement.getGrid() );
         layout.add( jsonWidgetElement.getType().toString() );
      }
      setStoryListData( namedRequestId, layout.toString());
   }

   private void assertCallingParty( final JsonMessage jsonMessage, final PhoneBookEntry phoneBookEntry )
   {
      evaluate( localStep( "Verify calling party in call incoming indication" )
            .details( match( "Is call incoming indication", jsonMessage.body().isCallIncomingIndication(),
                  equalTo( true ) ) )
            .details( match( "Calling party uri matches",
                  jsonMessage.body().callIncomingIndication().getCallingParty().getUri(),
                  equalTo( phoneBookEntry.getUri() ) ) )
            .details( match( "Calling party name matches",
                  jsonMessage.body().callIncomingIndication().getCallingParty().getName(),
                  equalTo( phoneBookEntry.getName() ) ) )
            .details( match( "Calling party full name matches",
                  jsonMessage.body().callIncomingIndication().getCallingParty().getFullName(),
                  equalTo( phoneBookEntry.getFullName() ) ) )
            .details( match( "Calling party location matches",
                  jsonMessage.body().callIncomingIndication().getCallingParty().getLocation(),
                  equalTo( phoneBookEntry.getLocation() ) ) )
            .details( match( "Calling party organization matches",
                  jsonMessage.body().callIncomingIndication().getCallingParty().getOrganization(),
                  equalTo( phoneBookEntry.getOrganization() ) ) )
            .details( match( "Calling party notes match",
                  jsonMessage.body().callIncomingIndication().getCallingParty().getNotes(),
                  equalTo( phoneBookEntry.getNotes() ) ) )
            .details( match( "Calling party display addon matches",
                  jsonMessage.body().callIncomingIndication().getCallingParty().getDisplayAddon(),
                  equalTo( phoneBookEntry.getDisplayAddon() ) ) ) );
   }


   private void assertCalledParty( final JsonMessage jsonMessage, final PhoneBookEntry phoneBookEntry )
   {
      evaluate( localStep( "Verify called party in call incoming indication" )
            .details( match( "Is call incoming indication", jsonMessage.body().isCallIncomingIndication(),
                  equalTo( true ) ) )
            .details( match( "Called party uri matches",
                  jsonMessage.body().callIncomingIndication().getCalledParty().getUri(),
                  equalTo( phoneBookEntry.getUri() ) ) )
            .details( match( "Called party name matches",
                  jsonMessage.body().callIncomingIndication().getCalledParty().getName(),
                  equalTo( phoneBookEntry.getName() ) ) )
            .details( match( "Called party full name matches",
                  jsonMessage.body().callIncomingIndication().getCalledParty().getFullName(),
                  equalTo( phoneBookEntry.getFullName() ) ) )
            .details( match( "Called party location matches",
                  jsonMessage.body().callIncomingIndication().getCalledParty().getLocation(),
                  equalTo( phoneBookEntry.getLocation() ) ) )
            .details( match( "Called party organization matches",
                  jsonMessage.body().callIncomingIndication().getCalledParty().getOrganization(),
                  equalTo( phoneBookEntry.getOrganization() ) ) )
            .details( match( "Called party notes match",
                  jsonMessage.body().callIncomingIndication().getCalledParty().getNotes(),
                  equalTo( phoneBookEntry.getNotes() ) ) )
            .details( match( "Called party display addon matches",
                  jsonMessage.body().callIncomingIndication().getCalledParty().getDisplayAddon(),
                  equalTo( phoneBookEntry.getDisplayAddon() ) ) ) );
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
                  containsString( getStoryData( callSourceName, String.class ) ) ) )
            .details(
                  match( "Called party matches", jsonMessage.body().callIncomingIndication().getCalledParty().getUri(),
                        containsString( getStoryData( callTargetName, String.class ) ) ) )
            .details( match( "AudioDirection matches", jsonMessage.body().callIncomingIndication().getAudioDirection(),
                  equalTo( audioDirection ) ) )
            .details( match( "Call priority matches", jsonMessage.body().callIncomingIndication().getCallPriority(),
                  equalTo( priority ) ) ) );

      setStoryData( phoneCallIdName, jsonMessage.body().callIncomingIndication().getCallId() );
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
                  equalTo( getStoryData( phoneCallIdName, String.class ) ) ) )
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

      final String callingParty = getStoryData( callSourceName, String.class );
      final String calledParty = getStoryData( callTargetName, String.class );

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

      final CallHoldRequest.Builder builder = CallHoldRequest.builder( getStoryData( phoneCallIdName, String.class ) );

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

      setStoryData( phoneCallIdName, jsonMessage.body().callEstablishResponse().getCallId() );
   }
}
