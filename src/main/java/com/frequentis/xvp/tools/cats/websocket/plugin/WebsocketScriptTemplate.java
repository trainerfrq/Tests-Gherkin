/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.tools.cats.websocket.plugin;

import java.util.List;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.frequentis.c4i.test.agent.websocket.client.api.ping.PingSender;
import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint;
import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpointManager;
import com.frequentis.c4i.test.agent.websocket.client.impl.models.ClientEndpointConfiguration;
import com.frequentis.c4i.test.agent.websocket.common.impl.buffer.MessageBuffer;
import com.frequentis.c4i.test.agent.websocket.common.impl.message.BinaryMessage;
import com.frequentis.c4i.test.agent.websocket.common.impl.message.JsonMessage;
import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage;
import com.frequentis.c4i.test.model.AutomationScript;
import com.frequentis.c4i.test.util.timer.WaitCondition;
import com.frequentis.c4i.test.util.timer.WaitTimer;

/**
 * Created by MAyar on 18.01.2017.
 */
public abstract class WebsocketScriptTemplate extends AutomationScript
{
   /**
    * The logger to be used by the script.
    */
   private static final Logger LOGGER = LoggerFactory.getLogger( WebsocketScriptTemplate.class );

   //Required by Findbugs
   static final long serialVersionUID = 1L;


   /**
    * Get the web socket endpoint clientEndpointManager.
    * @return The clientEndpointManager instance.
    */
   protected static ClientEndpointManager getWebSocketEndpointManager()
   {
      return ClientEndpointManager.getInstance();
   }


   /**
    * Sets the default endpoint configuration used when no config is specified when a new endpoint is created.
    *
    * @param configuration The WebSocketEndpointConfiguration instance.
    */
   protected void setDefaultWebSocketEndpointConfiguration( final ClientEndpointConfiguration configuration )
   {
      getWebSocketEndpointManager().setDefaultEndpointConfig( configuration );
   }


   /**
    * Gets the default endpoint configuration.
    * @return The default configuration.
    */
   protected ClientEndpointConfiguration getDefaultWebSocketEndpointConfiguration()
   {
      return getWebSocketEndpointManager().getDefaultEndpointConfig();
   }


   /**
    * Get the default web socket endpoint.
    * @return The endpoint.
    */
   protected ClientEndpoint getWebSocketEndpoint()
   {
      final ClientEndpointManager manager = getWebSocketEndpointManager();
      return manager != null ? manager.getWebSocketEndpoint() : null;
   }


   /**
    * Get the web socket client endpoint with a given key.
    *
    * @param endpointKey The key of a websocket entpoint instance.
    * @return The endpoint.
    */
   protected ClientEndpoint getWebSocketEndpoint( final String endpointKey )
   {
      final ClientEndpointManager manager = getWebSocketEndpointManager();
      return manager != null ? manager.getWebSocketEndpoint( endpointKey ) : null;
   }


   /**
    * Create a new WebSocket endpoint with default key and configuration.
    * @return The created endpoint.
    */
   protected ClientEndpoint createWebSocketEndpoint()
   {
      final ClientEndpointManager manager = getWebSocketEndpointManager();
      return manager != null ? manager.createWebSocketEndpoint() : null;
   }


   /**
    * Create a new WebSocket endpoint with a given key and configuration.
    * Different keys are necessary when multiple endpoints are instantiated per agent.
    *
    * @param endpointKey The key of a websocket entpoint instance.
    * @return The endpoint.
    */
   protected ClientEndpoint createWebSocketEndpoint( final String endpointKey )
   {
      final ClientEndpointManager manager = getWebSocketEndpointManager();
      return manager != null ? manager.createWebSocketEndpoint( endpointKey ) : null;
   }


   /**
    * Create a new WebSocket endpoint with a given configuration and the default key.
    *
    * @param configuration The WebSocketEndpointConfiguration instance used for creating the endpoint.
    * @return The endpoint.
    */
   protected ClientEndpoint createWebSocketEndpoint( final ClientEndpointConfiguration configuration )
   {
      final ClientEndpointManager manager = getWebSocketEndpointManager();
      return manager != null ? manager.createWebSocketEndpoint( configuration ) : null;
   }


   /**
    * Create a new WebSocket endpoint with a given key and a given configuration.
    * Different keys are necessary when multiple endpoints are instantiated per agent.
    *
    * @param endpointKey The key of a websocket entpoint instance.
    * @param configuration The WebSocketEndpointConfiguration instance used for creating the endpoint.
    * @return The endpoint.
    */
   protected ClientEndpoint createWebSocketEndpoint( final String endpointKey,
         final ClientEndpointConfiguration configuration )
   {
      final ClientEndpointManager manager = getWebSocketEndpointManager();
      return manager != null ? manager.createWebSocketEndpoint( endpointKey, configuration ) : null;
   }


   /**
    * Get the web socket client message buffer.
    *
    * @param endpointKey The key of a websocket endpoint instance.
    * @param bufferKey The key of a websocket endpoint message buffer.
    * @return The message buffer.
    */
   protected MessageBuffer getMessageBuffer( final String endpointKey, final String bufferKey )
   {
      MessageBuffer buffer = null;
      final ClientEndpointManager manager = getWebSocketEndpointManager();
      if ( manager != null )
      {
         final ClientEndpoint endpoint = manager.getWebSocketEndpoint( endpointKey );
         buffer = endpoint != null ? endpoint.getMessageBuffer( bufferKey ) : null;
      }
      return buffer;
   }


   /**
    * Get the default buffer of a web socket endpoint.
    *
    * @param endpointKey The key of a websocket endpoint instance.
    * @return The message buffer.
    */
   protected MessageBuffer getMessageBuffer( final String endpointKey )
   {
      return getMessageBuffer( endpointKey, null );
   }


   /**
    * Get the default message buffer of the default web socket endpoint.
    * @return The message buffer.
    */
   protected MessageBuffer getMessageBuffer()
   {
      return getMessageBuffer( null, null );
   }


   /**
    * Send the given text message on a given web socket endpoint.
    *
    * @param endpointKey The endpoint key.
    * @param message The message to send.
    * @return True if successful, otherwise false.
    */
   protected boolean sendText( final String endpointKey, final TextMessage message )
   {
      final ClientEndpoint endpoint = getWebSocketEndpoint( endpointKey );

      if ( endpoint != null )
      {
         try
         {
            if ( !endpoint.isConnected() )
            {
               LOGGER.error( "WebSocket Client Endpoint NOT Connected: [Key:'" + endpointKey + "', URI:'"
                     + endpoint.getUri() + "']" );
               return false;
            }
            return endpoint.sendText( message );
         }
         catch ( final Exception ex )
         {
            LOGGER.error( "Error sending text message: [Key:'" + endpointKey + "', Msg='" + message + "']", ex );
         }
      }
      else
      {
         LOGGER.error( "Error sending text message: [" + message + "]. Endpoint with key [" + endpointKey
               + "] couldn't be found." );
      }
      return false;
   }


   /**
    * Send the given text message via the default web socket endpoint.
    *
    * @param message The message to send.
    * @return True if successful, otherwise false.
    */
   protected boolean sendText( final TextMessage message )
   {
      return sendText( null, message );
   }


   /**
    * Send the given binary message on a given websocket endpoint.
    *
    * @param endpointKey The endpoint key.
    * @param message The message to send.
    * @return True if successful, otherwise false.
    */
   protected boolean sendBinary( final String endpointKey, final BinaryMessage message )
   {
      final ClientEndpoint endpoint = getWebSocketEndpoint( endpointKey );
      try
      {
         return endpoint.sendBinary( message );
      }
      catch ( final Exception ex )
      {
         LOGGER.error( "Error sending binary message: [" + message + "]", ex );
      }

      return false;
   }


   /**
    * Send the given binary message via the default web socket endpoint.
    *
    * @param message The message to send.
    * @return True if successful, otherwise false.
    */
   protected boolean sendBinary( final BinaryMessage message )
   {
      return sendBinary( null, message );
   }


   /**
    * Send the given json message via a given web socket endpoint.
    *
    * @param endpointKey The endpoint key.
    * @param message The message.
    * @return True if successful, otherwise false.
    */
   protected boolean sendJson( final String endpointKey, final JsonMessage message )
   {
      return sendText( endpointKey, message );
   }


   /**
    * Send the given json message via the default web socket endpoint.
    *
    * @param message The message.
    * @return True if successful, otherwise false.
    */
   protected boolean sendJson( final JsonMessage message )
   {
      return sendText( null, message );
   }


   /**
    * Polls for received text message in the default buffer of the default websocket endpoint.
    *
    * @return The message or null if not received within default wait timeout.
    */
   protected TextMessage receiveText()
   {
      return receiveText( null, null, -1 ); //-> using default wait timeout set for message buffer!
   }


   /**
    * Polls for received text message in the default buffer of the default websocket endpoint with a given timeout.
    *
    * @param nWait How long to wait for receiving buffered message.
    * @return The message or null if not received within given wait timeout.
    */
   protected TextMessage receiveText( final long nWait )
   {
      return receiveText( null, null, nWait );
   }


   /**
    * Polls for received text message in the default buffer of a given websocket endpoint.
    *
    * @param endpointKey The endpoint key.
    * @return The message or null if not received within default wait timeout.
    */
   protected TextMessage receiveText( final String endpointKey )
   {
      return receiveText( endpointKey, null, -1 ); //-> using default wait timeout set for message buffer!
   }


   /**
    * Polls for received text message in the default buffer of a given endpoint with a given timeout.
    *
    * @param endpointKey The endpoint key.
    * @param nWait How long to wait for receiving buffered message.
    * @return The message or null if not received within given wait timeout.
    */
   protected TextMessage receiveText( final String endpointKey, final long nWait )
   {
      return receiveText( endpointKey, null, nWait );
   }


   /**
    * Polls for received text message in a given buffer of a given endpoint with a given timeout.
    *
    * @param endpointKey The endpoint key.
    * @param bufferKey The buffer key.
    * @param nWait How long to wait for receiving buffered message.
    * @return The message or null if not received within given wait timeout.
    */
   protected TextMessage receiveText( final String endpointKey, final String bufferKey, final long nWait )
   {
      final MessageBuffer buffer = getMessageBuffer( endpointKey, bufferKey );
      if ( buffer != null )
      {
         try
         {
            return nWait > 0 ? buffer.pollTextMessage( nWait ) : buffer.pollTextMessage();
         }
         catch ( final Exception ex )
         {
            LOGGER.error( "Error receiving text message", ex );
         }
      }
      return null;
   }


   /**
    * Polls for received text messages in a given buffer of a given endpoint with a given timeout.
    *
    * @param endpointKey The endpoint key.
    * @param bufferKey The buffer key.
    * @param nMessageCount The number of messages to wait for.
    * @param nWait How long to wait for receiving buffered message in milliseconds.
    * @return The message or null if not received within given wait timeout.
    */
   protected List<TextMessage> receiveText( final String endpointKey, final String bufferKey, final int nMessageCount,
         final long nWait )
   {
      List<TextMessage> polledMessages = null;
      final MessageBuffer buffer = getMessageBuffer( endpointKey, bufferKey );
      if ( buffer != null )
      {
         try
         {
            final WaitCondition condition = new WaitCondition( "Wait for certain amount of messages" )
            {
               @Override
               public boolean test()
               {
                  return buffer.getTextMessagesCount() == nMessageCount;
               }
            };

            if ( WaitTimer.pause( condition, nWait ) )
            {
               polledMessages = buffer.pollAllTextMessages();
            }
         }
         catch ( final Exception ex )
         {
            LOGGER.error( "Error receiving text message", ex );
         }
      }
      else
      {
         LOGGER.error( "Couldn't find buffer with key [" + bufferKey + "] on endpoint [" + endpointKey + "]" );
      }
      return polledMessages;
   }


   /**
    * Polls for received binary message in the default buffer of the default websocket endpoint.
    *
    * @return The message or null if not received within default wait timeout.
    */
   protected BinaryMessage receiveBinary()
   {
      return receiveBinary( null, -1 ); //-> using default wait timeout set for message buffer!
   }


   /**
    * Polls for received binary message in the default buffer of a given websocket endpoint.
    *
    * @param endpointKey The endpoint key.
    * @return The message or null if not received within default wait timeout.
    */
   protected BinaryMessage receiveBinary( final String endpointKey )
   {
      return receiveBinary( endpointKey, -1 ); //-> using default wait timeout set for message buffer!
   }


   /**
    * Polls for received binary message in the default buffer of the default websocket endpoint with a given timeout.
    *
    * @param nWait How long to wait for receiving buffered message.
    * @return The message or null if not received within default wait timeout.
    */
   protected BinaryMessage receiveBinary( final long nWait )
   {
      return receiveBinary( null, nWait ); //-> using default wait timeout set for message buffer!
   }


   /**
    * Polls for received binary message in the default buffer of a given websocket endpoint with a given timeout.
    *
    * @param endpointKey The endpoint key.
    * @param nWait How long to wait for receiving buffered message.
    * @return The message or null if not received within given wait timeout.
    */
   protected BinaryMessage receiveBinary( final String endpointKey, final long nWait )
   {
      final MessageBuffer buffer = getMessageBuffer( endpointKey );
      if ( buffer != null )
      {
         try
         {
            return nWait > 0 ? buffer.pollBinaryMessage( nWait ) : buffer.pollBinaryMessage();
         }
         catch ( final Exception ex )
         {
            LOGGER.error( "Error receiving binary message", ex );
         }
      }
      return null;
   }


   /**
    * Polls for received binary messages in a given buffer of a given endpoint with a given timeout.
    *
    * @param endpointKey The endpoint key.
    * @param bufferKey The buffer key.
    * @param nMessageCount The number of messages to wait for.
    * @param nWait How long to wait for receiving buffered message in milliseconds.
    * @return The message or null if not received within given wait timeout.
    */
   protected List<BinaryMessage> receiveBinary( final String endpointKey, final String bufferKey,
         final int nMessageCount, final long nWait )
   {
      List<BinaryMessage> polledMessages = null;
      final MessageBuffer buffer = getMessageBuffer( endpointKey, bufferKey );
      if ( buffer != null )
      {
         try
         {
            final WaitCondition condition = new WaitCondition( "Wait for certain amount of messages" )
            {
               @Override
               public boolean test()
               {
                  return buffer.getBinaryMessagesCount() == nMessageCount;
               }
            };

            if ( WaitTimer.pause( condition, nWait ) )
            {
               polledMessages = buffer.pollAllBinaryMessages();
            }
         }
         catch ( final Exception ex )
         {
            LOGGER.error( "Error receiving binary messages", ex );
         }
      }
      else
      {
         LOGGER.error( "Couldn't find buffer with key [" + bufferKey + "] on endpoint [" + endpointKey + "]" );
      }
      return polledMessages;
   }


   /**
    * Start ping timer to send a certain TextMessage in a certain interval on the default websocket endpoint.
    *
    * @param pingInterval The ping interval.
    * @param timeUnit The TimeUnit of the ping interval value.
    * @param message The ping message to send.
    * @return True on success.
    */
   protected boolean startPing( final long pingInterval, final TimeUnit timeUnit, final TextMessage message )
   {
      return startPing( null, pingInterval, timeUnit, message );
   }


   /**
    * Start ping timer to send a certain TextMessage in a certain interval on a given websocket endpoint.
    *
    * @param endpointKey The key that identifies the target endpoint.
    * @param pingInterval The ping interval.
    * @param timeUnit The TimeUnit of the ping interval value.
    * @param message The ping message to send.
    * @return True on success.
    */
   protected boolean startPing( final String endpointKey, final long pingInterval, final TimeUnit timeUnit,
         final TextMessage message )
   {
      return startPing( endpointKey, pingInterval, timeUnit, message, -1, null );
   }


   /**
    * Start ping timer to send a certain TextMessage in a certain interval on a given websocket endpoint.
    *
    * @param endpointKey The key that identifies the target endpoint.
    * @param pingInterval The ping interval.
    * @param pingIntervalTimeUnit The TimeUnit of the ping interval value.
    * @param message The ping message to send.
    * @return True on success.
    */
   protected boolean startPing( final String endpointKey, final long pingInterval, final TimeUnit pingIntervalTimeUnit,
         final TextMessage message, final long delayInterval, final TimeUnit delayIntervalUnit )
   {
      final ClientEndpoint endpoint = getWebSocketEndpoint( endpointKey );
      if ( endpoint != null )
      {
         try
         {
            LOGGER.info( "Starting ping scheduler with ping interval: " + pingInterval );
            final long nanoDelayInterval =
                  delayInterval > 0 && delayIntervalUnit != null
                        ? TimeUnit.NANOSECONDS.convert( delayInterval, delayIntervalUnit ) : delayInterval;
            return endpoint.startPing( pingInterval, pingIntervalTimeUnit, message, nanoDelayInterval ) != null;
         }
         catch ( final Exception ex )
         {
            LOGGER.error( "Error starting ping scheduler with message: [" + message.toString() + "] and interval: ["
                  + pingInterval + "]", ex );
         }
      }
      else
      {
         LOGGER.error( "Error starting ping scheduler. Couldn't get websocket endpoint with endpoint key: '"
               + endpointKey + "'." );
      }
      return false;
   }


   /**
    * Stops sending ping messages on the default websocket endpoint.
    *
    * @return True on success.
    */
   protected boolean stopPing()
   {
      return stopPing( null );
   }


   /**
    * Gets the currently used PingSender instance of a given websocket endpoint.
    *
    * @param endpointKey The endpoint key.
    * @return The PingSender instance.
    */
   protected PingSender getPing( final String endpointKey )
   {
      final ClientEndpoint endpoint = getWebSocketEndpoint( endpointKey );
      PingSender pingSender = null;
      if ( endpoint != null )
      {
         try
         {
            pingSender = endpoint.getPing();
         }
         catch ( final Exception ex )
         {
            LOGGER.error( "Error getting ping scheduler", ex );
         }
      }
      else
      {
         LOGGER.error( "Error getting ping scheduler. Couldn't get websocket endpoint with endpoint key: '"
               + endpointKey + "'." );
      }
      return pingSender;
   }


   /**
    * Stops sending ping messages on a certain endpoint.
    *
    * @param endpointKey The target endpoint.
    * @return True on success.
    */
   protected boolean stopPing( final String endpointKey )
   {
      final ClientEndpoint endpoint = getWebSocketEndpoint( endpointKey );
      if ( endpoint != null )
      {
         try
         {
            endpoint.stopPing();
            return true;
         }
         catch ( final Exception ex )
         {
            LOGGER.error( "Error stopping ping schedular", ex );
         }
      }
      return false;
   }

}
