/************************************************************************
 ** PROJECT:   XVP
 ** LANGUAGE:  Java, J2SE JDK 1.8
 **
 ** COPYRIGHT: FREQUENTIS AG
 **            Innovationsstrasse 1
 **            A-1100 VIENNA
 **            AUSTRIA
 **            tel +43 1 811 50-0
 **
 ** The copyright to the computer program(s) herein
 ** is the property of Frequentis AG, Austria.
 ** The program(s) shall not be used and/or copied without
 ** the written permission of Frequentis AG.
 **
 ************************************************************************/
package com.frequentis.xvp.tools.cats.websocket.audio;

import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage;
import com.frequentis.c4i.test.agent.websocket.server.impl.Listener.DefaultWebSocketAdapterIOListener;
import com.frequentis.c4i.test.agent.websocket.server.impl.ServerEndpoint;
import com.frequentis.c4i.test.agent.websocket.server.impl.WebServerManager;
import com.frequentis.xvp.voice.audiointerface.json.messages.AudioInterfaceResponseResult;
import com.frequentis.xvp.voice.audiointerface.json.messages.ConferenceCommonResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.JsonMessage;
import com.frequentis.xvp.voice.audiointerface.json.messages.MessageType;
import com.frequentis.xvp.voice.audiointerface.json.messages.ResultCode;
import com.frequentis.xvp.voice.audiointerface.json.messages.client.AssociateResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.client.DisassociateResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.conference.AudioPortPair;
import com.frequentis.xvp.voice.audiointerface.json.messages.conference.AudioPortPairWithLevel;
import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.EpLogicPortMappingResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.LogicDevicePortMapping;
import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.LogicPortMapping;
import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.LogicPortMappingResult;
import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.signalling.EpLogicSignalEventResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.signalling.InputSignalEventResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.session.codec.Codec;
import com.frequentis.xvp.voice.audiointerface.json.messages.session.codec.CodecListResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.session.codec.CodecWithResult;
import com.frequentis.xvp.voice.audiointerface.json.messages.session.resource.AudioNetworkId;
import com.frequentis.xvp.voice.audiointerface.json.messages.session.resource.NetworkInterface;
import com.frequentis.xvp.voice.audiointerface.json.messages.session.resource.SessionResourceResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.session.resource.SinkPort;
import com.frequentis.xvp.voice.audiointerface.json.messages.session.resource.SinkPortWithResult;
import com.frequentis.xvp.voice.audiointerface.json.messages.sounddevice.IAuxDevicePortConfig;
import com.frequentis.xvp.voice.audiointerface.json.messages.sounddevice.SoundDeviceCommonResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.sounddevice.SoundDevicePortConfig;
import com.frequentis.xvp.voice.audiointerface.json.messages.sounddevice.SoundDeviceResult;
import com.frequentis.xvp.voice.audiointerface.json.messages.tonegeneration.ToneGenCommonResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.tonegeneration.ToneGenResult;
import com.frequentis.xvp.voice.audiointerface.json.messages.tonegeneration.ToneGenerator;
import com.frequentis.xvp.voice.audiointerface.json.messages.virtualport.SharedVirtualPortResult;
import com.frequentis.xvp.voice.audiointerface.json.messages.virtualport.VirtualPortCommonResponse;
import com.frequentis.xvp.voice.audiointerface.json.messages.virtualport.VirtualPortResult;
import com.google.gson.JsonSyntaxException;
import org.eclipse.jetty.websocket.api.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

public class AudioHandler extends DefaultWebSocketAdapterIOListener
{
   private static final Logger LOGGER = LoggerFactory.getLogger( AudioHandler.class );

   private static final AudioInterfaceResponseResult RESPONSE_RESULT = AudioInterfaceResponseResult
         .fromResultCode( ResultCode.Successful );

   private static final String AUDIO_NETWORK_HOST1_IP = "192.168.40.94";

   private static final String AUDIO_MACVLANDAUDIO_HOST1_IP = "192.168.60.94";

   private static int AUDIO_PORT = 3058;

   private static Session session;


   public static Session getSession(){
      return session;
   }

   @Override
   public void onWebSocketText( final TextMessage textMessage )
         throws IllegalArgumentException, IllegalStateException, JsonSyntaxException
   {
      final JsonMessage message = JsonMessage.fromJson( textMessage.getContent() );
      final UUID correlationId = message.header().correlationId();
      final MessageType messageType = message.body().getMessageType();
      WebServerManager manager = WebServerManager.getInstance();
      ServerEndpoint endpoint = manager.getServerEndpoint( getWebServerKey(), getWebSocketServletKey(),
            getWebSocketConnectionKey() );

         switch ( messageType )
         {
            case ASSOCIATE_REQUEST:
               if (message.body().associateRequest().clientName().equals("op-voice-phone")){
                  session = endpoint.getSession();
               }
               sendAssociateResponse( correlationId, endpoint );
               break;
            case DISASSOCIATE_REQUEST:
               sendDisassociateResponse( correlationId, endpoint );
               break;
            case EP_LOGIC_SIGNAL_EVENT_REQUEST:
               sendEpLogicSignalEventResponse( correlationId, endpoint );
               break;
            case TONE_GEN_CREATE_REQUEST:
               sendToneGenResult( correlationId, message, endpoint );
               break;
            case VIRTUAL_PORT_CREATE_REQUEST:
               sendVirtualPortCommonResponseResult( correlationId, message, endpoint );
               break;
            case SOUND_DEVICE_CONFIGURE_REQUEST:
               sendSoundDeviceCommonResponse( message, correlationId, endpoint );
               break;
            case EP_LOGIC_PORT_MAPPING_REQUEST:
               sendEpLogicPortMappingResponse( message, correlationId, endpoint );
               break;
            case EP_LOGIC_PORT_MAPPING_UPDATE_REQUEST:
               sendEpLogicPortMappingUpdateResponse( message, correlationId, endpoint );
               break;
            case CONNECT_PORT_REQUEST:
               sendConferenceCommonResponse( message, correlationId, endpoint );
               break;
            case DISCONNECT_PORT_REQUEST:
               sendConferenceCommonResponseForDisconnect( message, correlationId, endpoint );
               break;
            case SESSION_RESOURCE_REQUEST:
               sendSessionResourceResponse( message, correlationId, endpoint );
               break;
            case CODEC_LIST_REQUEST:
               sendCodecListResponse( correlationId, endpoint );
               break;
            case TONE_GEN_CONTROL_REQUEST:
               sendToneGenCommonResponse( message, correlationId, endpoint );
               break;
            default:
               LOGGER.warn( "Message of type {} unknown.", messageType );
               break;
         }
   }


   private void sendToneGenCommonResponse( final JsonMessage message, final UUID correlationId,
         final ServerEndpoint endpoint )
   {
      final List<ToneGenResult> toneGenResults = new ArrayList<>();
      for ( final ToneGenerator toneGenerator : message.body().toneGenControlRequest().getToneGenerators() )
      {
         toneGenResults.add( new ToneGenResult( toneGenerator.getToneGenId(), RESPONSE_RESULT ) );
      }
      JsonMessage jsonResponse = JsonMessage.builder()
            .withToneGenCommonResponse( new ToneGenCommonResponse( toneGenResults, RESPONSE_RESULT ) )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendEpLogicSignalEventResponse( final UUID correlationId, final ServerEndpoint endpoint )
   {
      List<InputSignalEventResponse> inputSignalEvResponse = new ArrayList<>();
      inputSignalEvResponse.add( InputSignalEventResponse.builder().withSignalId( "Op1Att" )
            .withResult( RESPONSE_RESULT ).build() );
      inputSignalEvResponse.add( InputSignalEventResponse.builder().withSignalId( "Co1Att" )
            .withResult( RESPONSE_RESULT ).build() );

      JsonMessage jsonResponse = JsonMessage.builder()
            .withEpLogicSignalEventResponse( EpLogicSignalEventResponse.builder().withInputSignalResults(
                  inputSignalEvResponse ).withResult( RESPONSE_RESULT ).build() )
            .withCorrelationId( correlationId )
            .build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendEpLogicPortMappingUpdateResponse( final JsonMessage message, final UUID correlationId,
         final ServerEndpoint endpoint )
   {
      final List<LogicPortMappingResult> portMappingResults = new ArrayList<>();
      final List<LogicPortMappingResult> devicePortMappingResults = new ArrayList<>();

      for ( LogicPortMapping logicPortMapping : message.body().epLogicPortMappingUpdateRequest().logicPortMappings() )
      {
         portMappingResults.add( LogicPortMappingResult.create( logicPortMapping.logicPortId(), RESPONSE_RESULT ) );
      }
      for ( LogicDevicePortMapping logicPortMapping : message.body().epLogicPortMappingUpdateRequest()
            .logicDevicePortMappings() )
      {
         devicePortMappingResults.add(
               LogicPortMappingResult.create( logicPortMapping.logicPortId(), RESPONSE_RESULT ) );
      }

      JsonMessage jsonResponse = JsonMessage.builder().withEpLogicPortMappingResponse( EpLogicPortMappingResponse
            .create( portMappingResults, devicePortMappingResults, RESPONSE_RESULT ) )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendCodecListResponse( final UUID correlationId, final ServerEndpoint endpoint )
   {
      final List<Codec> codecList = Arrays.asList(
            Codec.builder().withId( Codec.CodecId.PCMA ).build(),
            Codec.builder().withId( Codec.CodecId.PCMU ).build(),
            Codec.builder().withId( Codec.CodecId.CN ).build(),
            Codec.builder().withId( Codec.CodecId.R2S ).build() );
      JsonMessage jsonResponse = JsonMessage.builder().withCodecListResponse( CodecListResponse
            .newResponse( codecList, ResultCode.Successful, "" ) )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendConferenceCommonResponse( final JsonMessage message, final UUID correlationId,
         final ServerEndpoint endpoint )
   {
      final List<AudioInterfaceResponseResult> conferenceResults = new ArrayList<>();
      for ( AudioPortPairWithLevel results : message.body().connectPortRequest().getConnections())
      {
         conferenceResults.add( RESPONSE_RESULT );
      }
      JsonMessage jsonResponse = JsonMessage.builder().withConferenceCommonResponse( ConferenceCommonResponse
            .create( conferenceResults, RESPONSE_RESULT ) )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendConferenceCommonResponseForDisconnect( final JsonMessage message, final UUID correlationId,
                                              final ServerEndpoint endpoint )
   {
      final List<AudioInterfaceResponseResult> conferenceResults = new ArrayList<>();
      for ( AudioPortPair results : message.body().disconnectPortRequest().getConnections())
      {
         conferenceResults.add( RESPONSE_RESULT );
      }
      JsonMessage jsonResponse = JsonMessage.builder().withConferenceCommonResponse( ConferenceCommonResponse
              .create( conferenceResults, RESPONSE_RESULT ) )
              .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendEpLogicPortMappingResponse( final JsonMessage message, final UUID correlationId,
         final ServerEndpoint endpoint )
   {
      final List<LogicPortMappingResult> portMappingResults = new ArrayList<>();
      final List<LogicPortMappingResult> devicePortMappingResults = new ArrayList<>();

      for ( LogicPortMapping logicPortMapping : message.body().epLogicPortMappingRequest().logicPortMappings() )
      {
         portMappingResults.add( LogicPortMappingResult.create( logicPortMapping.logicPortId(), RESPONSE_RESULT ) );
      }
      for ( LogicDevicePortMapping logicPortMapping : message.body().epLogicPortMappingRequest().logicDevicePortMappings() )
      {
         devicePortMappingResults.add(
               LogicPortMappingResult.create( logicPortMapping.logicPortId(), RESPONSE_RESULT ) );
      }

      JsonMessage jsonResponse = JsonMessage.builder()
            .withEpLogicPortMappingResponse( EpLogicPortMappingResponse
                  .create( portMappingResults, devicePortMappingResults,
                        RESPONSE_RESULT ) )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendSoundDeviceCommonResponse( final JsonMessage message, final UUID correlationId,
         final ServerEndpoint endpoint )
   {
      final List<SoundDeviceResult> iAuxDeviceResults = new ArrayList<>();
      for ( IAuxDevicePortConfig iAuxId : message.body().soundDeviceConfigureRequest().iAuxDevicePortConfigs() )
      {
         iAuxDeviceResults.add( SoundDeviceResult.create( iAuxId.port(), RESPONSE_RESULT ) );
      }
      final List<SoundDeviceResult> soundDeviceResults = new ArrayList<>();
      for ( SoundDevicePortConfig soundConfig : message.body().soundDeviceConfigureRequest().soundDevicePortConfigs() )
      {
         soundDeviceResults.add( SoundDeviceResult.create( soundConfig.port(), RESPONSE_RESULT ) );
      }
      JsonMessage jsonResponse = JsonMessage.builder()
            .withSoundDeviceCommonResponse( SoundDeviceCommonResponse.builder( RESPONSE_RESULT )
                  .withiAuxDeviceResults( iAuxDeviceResults )
                  .withSoundDeviceResults( soundDeviceResults ).build() )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendToneGenResult( final UUID correlationId, final JsonMessage message, final ServerEndpoint endpoint )
   {
      final List<ToneGenResult> toneGenResults = new ArrayList<>();
      for ( String toneGenId : message.body().toneGenCreateRequest().getToneGenIds() )
      {
         toneGenResults.add( new ToneGenResult( toneGenId, RESPONSE_RESULT ) );
      }
      JsonMessage jsonResponse = JsonMessage.builder()
            .withToneGenCommonResponse( new ToneGenCommonResponse( toneGenResults, RESPONSE_RESULT ) )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendVirtualPortCommonResponseResult( final UUID correlationId, final JsonMessage message,
         final ServerEndpoint endpoint )
   {
      final List<VirtualPortResult> virtualPortResults = new ArrayList<>();
      for ( String virtualPortId : message.body().virtualPortCreateRequest().getVirtualPortIds() )
      {
         virtualPortResults.add( VirtualPortResult.create( RESPONSE_RESULT, virtualPortId ) );
      }

      final List<SharedVirtualPortResult> sharedVirtualPortResults = new ArrayList<>();
      for ( String sharedVirtualPortId : message.body().virtualPortCreateRequest().getSharedVirtualPortIds() )
      {
         sharedVirtualPortResults.add( SharedVirtualPortResult.create( RESPONSE_RESULT, sharedVirtualPortId ) );
      }
      JsonMessage jsonResponse = JsonMessage.builder()
            .withVirtualPortCommonResponse( VirtualPortCommonResponse
                  .create( RESPONSE_RESULT, virtualPortResults, sharedVirtualPortResults ) )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendSessionResourceResponse( final JsonMessage message, final UUID correlationId,
         final ServerEndpoint endpoint )
   {
      final List<SinkPortWithResult> sinkPortsResults = new ArrayList<>();
      for ( SinkPort sinkPort : message.body().sessionResourceRequest().sinkPorts() ) {
         sinkPortsResults.add(SinkPortWithResult.builder().withPrivateId(sinkPort.privateId())
                 .withPort(AUDIO_PORT += 2).withResult(RESPONSE_RESULT).build());
      }
      List<NetworkInterface> networkResults = Arrays.asList(
            new NetworkInterface( AudioNetworkId.LAN_A, AUDIO_MACVLANDAUDIO_HOST1_IP ),
            new NetworkInterface( AudioNetworkId.DATA_NETWORK, AUDIO_NETWORK_HOST1_IP ) );
      List<CodecWithResult> codecResults = new ArrayList<>();

      JsonMessage jsonResponse = JsonMessage.builder().withSessionResourceResponse( SessionResourceResponse
            .newResponse( networkResults, sinkPortsResults, codecResults, ResultCode.Successful, "Success!" ) )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendDisassociateResponse( final UUID correlationId, final ServerEndpoint endpoint )
   {
      JsonMessage jsonResponse = JsonMessage.builder()
            .withDisassociateResponse( DisassociateResponse.ok( "Success!" ) )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }


   private void sendAssociateResponse( final UUID correlationId, final ServerEndpoint endpoint )
   {
      JsonMessage jsonResponse = JsonMessage.builder().withAssociateResponse(
            AssociateResponse.newResponse( ResultCode.Successful, "Success!" ) )
            .withCorrelationId( correlationId ).build();
      endpoint.sendText( new TextMessage( jsonResponse.toString() ) );
   }
}
