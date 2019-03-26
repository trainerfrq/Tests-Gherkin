/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.tools.cats.websocket.automation.steps;

import com.frequentis.c4i.test.agent.websocket.client.impl.models.ClientEndpointConfiguration;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionData;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;
import com.frequentis.xvp.tools.cats.websocket.automation.model.ProfileToWebSocketConfigurationReference;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.tools.cats.websocket.dto.WebsocketAutomationSteps;
import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.websocket.parallel.OpenAndVerifyWebSocketClientConnection;
import scripts.cats.websocket.parallel.OpenWebSocketClientConnection;
import scripts.cats.websocket.parallel.OpenWebSocketClientConnectionToAudio;
import scripts.cats.websocket.parallel.SendTextMessageAsIsParallel;
import scripts.cats.websocket.sequential.CloseWebSocketClientConnection;
import scripts.cats.websocket.sequential.ReceiveMessageAsIs;
import scripts.cats.websocket.sequential.SendTextMessageAsIs;
import scripts.cats.websocket.sequential.StartClientConnectionRecording;
import scripts.cats.websocket.sequential.buffer.ClearMessageBuffer;
import scripts.cats.websocket.sequential.buffer.OpenMessageBuffer;
import scripts.cats.websocket.sequential.buffer.RemoveCustomMessageBuffer;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by MAyar on 18.01.2017.
 */
public class WebsocketClientRemoteSteps extends WebsocketAutomationSteps
{

   @Given("applied the websocket configuration: $references")
   @Alias("the opened websocket configuration: $references")
   public void openNamedWebSocketConnections(
         final List<ProfileToWebSocketConfigurationReference> namedProfileToWebSocketConfigReferences )
   {
      if ( namedProfileToWebSocketConfigReferences.size() == 0 )
      {
         localStep( "looking into tables for parsing" )
               .details( ExecutionDetails.create( "Parsing Table" ).expected( "Table contains at least one entry" )
                     .received( "NO ENTRY FOUND " + namedProfileToWebSocketConfigReferences ).success( false ) );
      }

      int i = 1;
          for (final ProfileToWebSocketConfigurationReference reference : namedProfileToWebSocketConfigReferences) {
              final ExecutionData data = new ExecutionData();

              reference.setKey("WS" + i);
              localStep( "Parsing Table" ).details( ExecutionDetails
               .create( "Parse data table. Entry " + i + " of " + namedProfileToWebSocketConfigReferences.size() )
               .expected( "ExamplesTable can be parsed" ).receivedData( reference.getKey(), reference )
               .success( true ) );
              final ClientEndpointConfiguration config =
                      getStoryListData(reference.getWebSocketConfigurationName(), ClientEndpointConfiguration.class);

              final ArrayList<String> endpointName = new ArrayList<String>();
              endpointName.add(reference.getKey());

              RemoteStepResult remoteStepResult =
                      evaluate(
                              remoteStep( "Open websocket connection " + reference.getWebSocketConfigurationName() )
                                      .scriptOn(profileScriptResolver().map(OpenWebSocketClientConnection.class,
                                              BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                      .input(OpenWebSocketClientConnection.IPARAM_ENDPOINTCONFIGURATION, (Serializable) config)
                                      .input(OpenWebSocketClientConnection.IPARAM_MULTIPLEENDPOINTNAMES, endpointName));

              final String jsonResponse =
                      (String) remoteStepResult.getOutput(OpenWebSocketClientConnection.OPARAM_RECEIVEDMESSAGE);

              if (jsonResponse.contains("Active")) {
                  // add the named reference between websocket config and profile to the user named parameters
                  setStoryListData(reference.getKey(), reference);
                  i++;
              }
              else if (jsonResponse.contains("Passive")){
                 evaluate(
                         remoteStep( "Close passive websocket connection " + reference.getWebSocketConfigurationName() )
                                 .scriptOn( profileScriptResolver().map( CloseWebSocketClientConnection.class,
                                         BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                                 .input( CloseWebSocketClientConnection.IPARAM_ENDPOINTNAME, reference.getKey() ) );
                 endpointName.remove(reference.getKey());
              }
          }
   }


   @Given("applied the named websocket configuration: $references")
   public void openNamedWebSocketConnectionsToAudio(
         final List<ProfileToWebSocketConfigurationReference> namedProfileToWebSocketConfigReferences )
   {
      if ( namedProfileToWebSocketConfigReferences.size() == 0 )
      {
         localStep( "looking into tables for parsing" )
               .details( ExecutionDetails.create( "Parsing Table" ).expected( "Table contains at least one entry" )
                     .received( "NO ENTRY FOUND " + namedProfileToWebSocketConfigReferences ).success( false ) );
      }

      int i = 1;
      for (final ProfileToWebSocketConfigurationReference reference : namedProfileToWebSocketConfigReferences) {
         final ExecutionData data = new ExecutionData();

         reference.setKey("WS" + i);
         localStep( "Parsing Table" ).details( ExecutionDetails
               .create( "Parse data table. Entry " + i + " of " + namedProfileToWebSocketConfigReferences.size() )
               .expected( "ExamplesTable can be parsed" ).receivedData( reference.getKey(), reference )
               .success( true ) );
         final ClientEndpointConfiguration config =
               getStoryListData(reference.getWebSocketConfigurationName(), ClientEndpointConfiguration.class);

         final ArrayList<String> endpointName = new ArrayList<String>();
         endpointName.add(reference.getKey());

         RemoteStepResult remoteStepResult =
               evaluate(
                     remoteStep( "Open websocket connection " + reference.getWebSocketConfigurationName() )
                           .scriptOn(profileScriptResolver().map( OpenWebSocketClientConnectionToAudio.class,
                                 BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                           .input(OpenWebSocketClientConnectionToAudio.IPARAM_ENDPOINTCONFIGURATION, config)
                           .input(OpenWebSocketClientConnectionToAudio.IPARAM_MULTIPLEENDPOINTNAMES, endpointName));
         setStoryListData(reference.getKey(), reference);
         i++;
      }
   }


   @Given("it is known what op voice instances are $state, the websocket configuration is applied: $references")
   @Alias("that connection can be open (although instances are $state) using websocket configuration: $references")
   public void openNamedActiveWebSocketConnections(final String state,
                                                   final List<ProfileToWebSocketConfigurationReference> namedProfileToWebSocketConfigReferences )
   {
      if ( namedProfileToWebSocketConfigReferences.size() == 0 )
      {
         localStep( "looking into tables for parsing" )
                 .details( ExecutionDetails.create( "Parsing Table" ).expected( "Table contains at least one entry" )
                         .received( "NO ENTRY FOUND " + namedProfileToWebSocketConfigReferences ).success( false ) );
      }

      int i = 1;
      for ( final ProfileToWebSocketConfigurationReference reference : namedProfileToWebSocketConfigReferences ) {
         final ExecutionData data = new ExecutionData();
         setStoryListData( reference.getKey(), reference );

         final ClientEndpointConfiguration config =
                 getStoryListData(reference.getWebSocketConfigurationName(), ClientEndpointConfiguration.class);
         final ArrayList<String> endpointName = new ArrayList<String>();
         endpointName.add( reference.getKey());

         final RemoteStepResult remoteStepResult =
                 evaluate( remoteStep( "Open websocket connection " + reference.getWebSocketConfigurationName() )
                         .scriptOn(profileScriptResolver().map(OpenAndVerifyWebSocketClientConnection.class,
                                 BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                         .input(OpenAndVerifyWebSocketClientConnection.IPARAM_ENDPOINTCONFIGURATION, (Serializable) config)
                         .input(OpenAndVerifyWebSocketClientConnection.IPARAM_MULTIPLEENDPOINTNAMES, endpointName));

         final String redundancyState =
                 (String) remoteStepResult.getOutput(OpenAndVerifyWebSocketClientConnection.OPARAM_RECEIVEDMESSAGE);
         setStoryListData(reference.getWebSocketConfigurationName(), redundancyState);
         if(redundancyState.contains("Passive")){
            evaluate(
                    remoteStep( "Close passive websocket connection " + reference.getWebSocketConfigurationName() )
                            .scriptOn( profileScriptResolver().map( CloseWebSocketClientConnection.class,
                                    BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                            .input( CloseWebSocketClientConnection.IPARAM_ENDPOINTNAME, reference.getKey() ) );
            endpointName.remove(reference.getKey());
         }
         final LocalStep step = localStep( "Redundancy state" );
         step.details( ExecutionDetails.create( "Verify redundancy state " )
                 .expected( state )
                 .received( redundancyState)
                 .success( redundancyState.contains(state) ) );
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
         evaluate( checkReceivedMessage.details( ExecutionDetails.create( "Check received Message" )
               .received( receviedMessage ).expected( expectedMessageString )
               .success( receviedMessage.contains( expectedMessageString ) ) ) );
         setStoryListData( namedTimeStamp, remoteStepResult.getOutput( ReceiveMessageAsIs.OPARAM_ACTIONTIME ) );
      }
   }


   @Then("using the websocket $namedWebSocket websocket message is received and validated against the expected message $expectedMessage and $parameter in the message saved as $namedParameter")
   public void receiveMessageSaveParameter( final String namedWebSocket, final String expectedMessage,
         final String parameter, final String namedParameter )
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
         evaluate( checkReceivedMessage.details( ExecutionDetails.create( "Check received Message" )
               .received( receviedMessage ).expected( expectedMessageString )
               .success( receviedMessage.contains( expectedMessageString ) ) ) );
         if ( receviedMessage.contains( parameter ) )
         {
            setStoryListData( namedParameter, receviedMessage.split( parameter )[1].split( "," )[0] );
         }

      }
   }


   @Then("using the websocket $namedWebSocket websocket message is received with time stamp $namedTimeStamp and validated against the expected message $expectedMessage and $parameter in the message saved as $namedParameter")
   public void receiveMessageSaveParameter( final String namedWebSocket, final String namedTimeStamp,
         final String expectedMessage, final String parameter, final String namedParameter )
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
         evaluate( checkReceivedMessage.details( ExecutionDetails.create( "Check received Message" )
               .received( receviedMessage ).expected( expectedMessageString )
               .success( receviedMessage.contains( expectedMessageString ) ) ) );
         if ( receviedMessage.contains( parameter ) )
         {
            setStoryListData( namedParameter, receviedMessage.split( parameter )[1].split( "," )[0] );
            setStoryListData( namedTimeStamp, remoteStepResult.getOutput( ReceiveMessageAsIs.OPARAM_ACTIONTIME ) );
         }

      }
   }


   @When("$namedWebSocket opens the message buffer for message type $messageType named $bufferName")
   public void openCustomMessageBuffer( final String namedWebSocket, final String messageType, final String bufferName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      evaluate( remoteStep( "Create the message buffer named: " + bufferName + " with filter type: " + messageType )
            .scriptOn( profileScriptResolver().map( OpenMessageBuffer.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( OpenMessageBuffer.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( OpenMessageBuffer.IPARAM_BUFFERKEY, bufferName )
            .input( OpenMessageBuffer.IPARAM_MESSAGETYPE, messageType ) );
   }


   @When("the named websocket $namedWebSocket removes the message buffer named $bufferName")
   public void removeCustomMessageBuffer( final String namedWebSocket, final String bufferName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      evaluate( remoteStep( "Remove the message buffer: " + bufferName )
            .scriptOn( profileScriptResolver().map( RemoveCustomMessageBuffer.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( RemoveCustomMessageBuffer.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( RemoveCustomMessageBuffer.IPARAM_BUFFERKEY, bufferName ) );
   }


   @When("$namedWebSocket clears all text messages from buffer named $bufferName")
   public void clearCustomMessageBuffer( final String namedWebSocket, final String bufferName )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      evaluate( remoteStep( "Clear the message buffer: " + bufferName )
            .scriptOn( profileScriptResolver().map( ClearMessageBuffer.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( RemoveCustomMessageBuffer.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( RemoveCustomMessageBuffer.IPARAM_BUFFERKEY, bufferName ) );
   }


   @When("$namedWebSocket closes websocket client connection")
   public void closeWebSocketConnection( final String namedWebSocket )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      evaluate(
            remoteStep( "Start recording on named WebSocket: " + namedWebSocket )
                  .scriptOn( profileScriptResolver().map( CloseWebSocketClientConnection.class,
                        BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                  .input( CloseWebSocketClientConnection.IPARAM_ENDPOINTNAME, reference.getKey() ) );
   }


   private String getOpVoiceServiceRedundancyState(final ProfileToWebSocketConfigurationReference reference )
   {
      final ExecutionData data = new ExecutionData();
      setStoryListData( reference.getKey(), reference );

      final ClientEndpointConfiguration config =
              getStoryListData(reference.getWebSocketConfigurationName(), ClientEndpointConfiguration.class);
      final ArrayList<String> endpointName = new ArrayList<String>();
      endpointName.add( reference.getKey());

      final RemoteStepResult remoteStepResult =
              evaluate( remoteStep( "Open websocket connection " + reference.getWebSocketConfigurationName() )
                      .scriptOn(profileScriptResolver().map(OpenAndVerifyWebSocketClientConnection.class,
                              BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                      .input(OpenAndVerifyWebSocketClientConnection.IPARAM_ENDPOINTCONFIGURATION, (Serializable) config)
                      .input(OpenAndVerifyWebSocketClientConnection.IPARAM_MULTIPLEENDPOINTNAMES, endpointName));

      final String jsonResponse =
              (String) remoteStepResult.getOutput(OpenAndVerifyWebSocketClientConnection.OPARAM_RECEIVEDMESSAGE);

      return jsonResponse;
   }
}
