/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.cats.websocket.automation.steps;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.agent.websocket.client.impl.models.ClientEndpointConfiguration;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStep;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepExecution;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionData;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;
import com.frequentis.cats.websocket.automation.model.ProfileToWebSocketConfigurationReference;
import com.frequentis.cats.websocket.dto.BookableProfileName;
import com.frequentis.cats.websocket.dto.WebsocketAutomationSteps;

import scripts.cats.websocket.parallel.OpenWebSocketClientConnection;
import scripts.cats.websocket.parallel.SendTextMessageAsIsParallel;
import scripts.cats.websocket.sequential.ReceiveMessageAsIs;
import scripts.cats.websocket.sequential.SendTextMessageAsIs;
import scripts.cats.websocket.sequential.StartClientConnectionRecording;

/**
 * Created by MAyar on 18.01.2017.
 */
public class WebsocketClientRemoteSteps extends WebsocketAutomationSteps
{

   @Given("applied the websocket configuration: $references")
   public void openNamedWebSocketConnections(
         final List<ProfileToWebSocketConfigurationReference> namedProfileToWebSocketConfigReferences )
   {
      final RemoteStep remStep = remoteStep( "Parsing Datatables paralelly" );
      RemoteStepExecution execution = null;
      if ( namedProfileToWebSocketConfigReferences.size() == 0 )
      {
         localStep( "looking into tables for parsing" )
               .details( ExecutionDetails.create( "Parsing Table" ).expected( "Table contains at least one entry" )
                     .received( "NO ENTRY FOUND " + namedProfileToWebSocketConfigReferences ).success( false ) );
      }

      int i = 1;
      for ( final ProfileToWebSocketConfigurationReference reference : namedProfileToWebSocketConfigReferences )
      {
         // add the named reference between websocket config and profile to the user named parameters
         setStoryListData( reference.getKey(), reference );
         final ExecutionData data = new ExecutionData();
         localStep( "Parsing Table" ).details( ExecutionDetails
               .create( "Parse data table. Entry " + i++ + " of " + namedProfileToWebSocketConfigReferences.size() )
               .expected( "ExamplesTable can be parsed" ).receivedData( reference.getKey(), reference )
               .success( true ) );
         final ClientEndpointConfiguration config =
               getStoryListData( reference.getWebSocketConfigurationName(), ClientEndpointConfiguration.class );

         final ArrayList<String> endpointName = new ArrayList<String>();
         endpointName.add( reference.getKey() );

         execution =
               remStep
                     .scriptOn( profileScriptResolver().map( OpenWebSocketClientConnection.class,
                           BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                     .input( OpenWebSocketClientConnection.IPARAM_ENDPOINTCONFIGURATION, ( Serializable ) config )
                     .input( OpenWebSocketClientConnection.IPARAM_MULTIPLEENDPOINTNAMES, endpointName );
      }

      if ( execution != null )
      {
         evaluate( execution );
      }
   }


   @Then("start recording on named websocket $namedWebSocket with a buffer size of $bufferSize")
   public void startRecordingOnNamedWebSocket( final String namedWebSocket, final Integer bufferSize )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      evaluate(
            remoteStep( "Start recording on named WebSocket: " + namedWebSocket )
                  .scriptOn( profileScriptResolver().map( StartClientConnectionRecording.class,
                        BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                  .input( StartClientConnectionRecording.IPARAM_ENDPOINTNAME, reference.getKey() )
                  .input( StartClientConnectionRecording.IPARAM_BUFFERSIZE, bufferSize ) );
   }


   @When("using the websocket $namedWebSocket the message named $namedMessage is sent as is with time stamp $namedTimeStamp")
   public void sendMessageAsIsOverNamedWebSocketAndNameMessage( final String namedWebSocket, final String namedMessage,
         final String namedTimeStamp )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );
      final String messageToSend = assertStoryListData( namedMessage, String.class );
      final RemoteStepResult remoteStepResult =
            evaluate( remoteStep( "Sending message with using " + namedWebSocket )
                  .scriptOn( profileScriptResolver().map( SendTextMessageAsIs.class, BookableProfileName.websocket ),
                        requireProfile( reference.getProfileName() ) )
                  .input( SendTextMessageAsIs.IPARAM_ENDPOINTNAME, namedWebSocket )
                  .input( SendTextMessageAsIs.IPARAM_MESSAGETOSEND, messageToSend ) );
      setStoryListData( namedTimeStamp, remoteStepResult.getOutput( SendTextMessageAsIs.OPARAM_ACTIONTIME ) );

   }


   @When("using the websocket $namedWebSocket the messages are sent: $namedMessageList")
   public void sendMessagesAsIsOverNamedWebSocket( final String namedWebSocket,
         final List<CatsCustomParameterBase> namedMessageList )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );
      final List<String> messageToSendList = new ArrayList<>();
      for ( final CatsCustomParameterBase parameter : namedMessageList )
      {
         final String namedMessageKey = parameter.getKey();
         final String messageToSend = assertStoryListData( namedMessageKey, String.class );
         messageToSendList.add( messageToSend );
      }
      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Sending message with using " + namedWebSocket )
                        .scriptOn( profileScriptResolver().map( SendTextMessageAsIsParallel.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendTextMessageAsIsParallel.IPARAM_ENDPOINTNAME, namedWebSocket ).input(
                              SendTextMessageAsIsParallel.IPARAM_MESSAGETOSEND, ( Serializable ) messageToSendList ) );
   }


   @When("using the websocket $namedWebSocket the messages in group $group will be sent simultaneously")
   public void sendMessagesAsIsOverNamedWebSocket( final String namedWebSocket, final String group )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );
      ArrayList<String> messageToSendList = new ArrayList<>();
      messageToSendList = assertStoryListData( group, ArrayList.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Sending message with using " + namedWebSocket )
                        .scriptOn( profileScriptResolver().map( SendTextMessageAsIsParallel.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendTextMessageAsIsParallel.IPARAM_ENDPOINTNAME, namedWebSocket ).input(
                              SendTextMessageAsIsParallel.IPARAM_MESSAGETOSEND, ( Serializable ) messageToSendList ) );

   }


   @Then("using the websocket $namedWebSocket websocket message is received and validated against the expected message $expectedMessage with time stamp $namedTimeStamp")
   public void receiveMessageAndValidate( final String namedWebSocket, final String expectedMessage,
         final String namedTimeStamp )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate( remoteStep( "Sending message with using " + namedWebSocket )
                  .scriptOn( profileScriptResolver().map( ReceiveMessageAsIs.class, BookableProfileName.websocket ),
                        requireProfile( reference.getProfileName() ) )
                  .input( ReceiveMessageAsIs.IPARAM_ENDPOINTNAME, namedWebSocket ) );
      final String receviedMessage = ( String ) remoteStepResult.getOutput( ReceiveMessageAsIs.OPARAM_RECEIVEDMESSAGE );
      final String expectedMessageString = assertStoryListData( expectedMessage, String.class );
      if ( receviedMessage != null )
      {
         final LocalStep checkReceivedMessage = localStep( "Check received Message" );
         checkReceivedMessage.details( ExecutionDetails.create( "Check received Message" ).received( receviedMessage )
               .expected( expectedMessageString ).success( receviedMessage.contains( expectedMessageString ) ) );
         setStoryListData( namedTimeStamp, remoteStepResult.getOutput( ReceiveMessageAsIs.OPARAM_ACTIONTIME ) );
      }
   }
}
