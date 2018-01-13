/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.tools.cats.websocket.converter;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.net.URI;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.jbehave.core.model.ExamplesTable;
import org.jbehave.core.model.ExamplesTableFactory;
import org.jbehave.core.steps.ParameterConverters;

import com.frequentis.c4i.test.agent.websocket.client.impl.models.ClientEndpointConfiguration;
import com.frequentis.c4i.test.agent.websocket.client.impl.models.HttpAuthenticationConfiguration;
import com.frequentis.xvp.tools.cats.websocket.dto.DataSets;

/**
 * Created by MAyar on 18.01.2017.
 */
public class ClientEndpointConfigurationConverter implements ParameterConverters.ParameterConverter
{

   /**
    * The logger to be used.
    */
   private static final Logger LOG = Logger.getLogger( ClientEndpointConfigurationConverter.class.getName() );


   @Override
   public boolean accept( final Type type )
   {
      if ( type instanceof ParameterizedType )
      {
         for ( final Type subType : (( ParameterizedType ) type).getActualTypeArguments() )
         {
            if ( subType instanceof Class
                  && ClientEndpointConfiguration.class.isAssignableFrom( ( Class<?> ) subType ) )
            {
               return true;
            }
         }
      }
      return false;
   }


   @Override
   public Map<String, ClientEndpointConfiguration> convertValue( final String value, final Type type )
   {
      final ExamplesTableFactory factory = new ExamplesTableFactory();
      final ExamplesTable table = factory.createExamplesTable( value );
      final Map<String, ClientEndpointConfiguration> connections = new HashMap<String, ClientEndpointConfiguration>();

      for ( int i = 0; i < table.getRowCount(); i++ )
      {
         final ClientEndpointConfiguration connection = new ClientEndpointConfiguration();

         LOG.log( Level.INFO, "Created new ClientEndpointConfiguration: " + i );
         try
         {
            final Map<String, String> row = table.getRow( i );

            // URI
            final URI wsUri = new URI( row.get( Parameter.WebSocketUri ) );
            connection.setWebSocketUri( wsUri );

            // Text buffer size
            final String textBufferString = row.get( Parameter.TextBufferSize );
            if ( textBufferString != null )
            {
               connection.setTextBufferSize( Integer.valueOf( textBufferString ) );
            }
            else
            {
               connection.setTextBufferSize( ClientEndpointConfiguration.DEFAULT_TEXT_BUFFER_SIZE );
            }

            // Binary buffer size
            final String binaryBufferString = row.get( Parameter.BinaryBufferSize );
            if ( binaryBufferString != null )
            {
               connection.setBinaryBufferSize( Integer.valueOf( binaryBufferString ) );
            }
            else
            {
               connection.setTextBufferSize( ClientEndpointConfiguration.DEFAULT_BINARY_BUFFER_SIZE );
            }

            // Default message wait timeout
            final String messageWaitTimeoutString = row.get( Parameter.MessageWaitTimeout );
            if ( messageWaitTimeoutString != null )
            {
               connection.setMessageWaitTimeout( Long.valueOf( messageWaitTimeoutString ) );
            }

            // Start after initialization
            final String startAfterInitString = row.get( Parameter.StartAfterInitialization );
            if ( startAfterInitString != null )
            {
               connection.setStartAfterInitialization( Boolean.valueOf( startAfterInitString ) );
            }
            else
            {
               connection.setStartAfterInitialization( ClientEndpointConfiguration.DEFAULT_START_AFTER_INITIALIZATION );
            }

            // Authentication
            final String authUser = row.get( Parameter.AuthUsername );
            final String authPassword = row.get( Parameter.AuthPassword );
            Long authTimeout = null;
            final String authTimeoutString = row.get( Parameter.AuthTimeout );
            if ( authTimeoutString != null && !authTimeoutString.isEmpty() )
            {
               authTimeout = Long.valueOf( authTimeoutString );
            }

            if ( authUser != null && !authUser.isEmpty() && authPassword != null )
            {
               final HttpAuthenticationConfiguration httpAuthConfig =
                     new HttpAuthenticationConfiguration( authUser, authPassword, authTimeout );
               connection.setHttpAuthenticationConfiguration( httpAuthConfig );
            }

            // SSL
            final String keyStorePath = row.get( Parameter.KeyStorePath );
            if ( keyStorePath != null )
            {
               connection.setKeyStorePath( keyStorePath );
            }
            final String keyStorePassword = row.get( Parameter.KeyStorePassword );
            if ( keyStorePassword != null )
            {
               connection.setKeyStorePassword( keyStorePassword );
            }
            final String trustAllString = row.get( Parameter.KeyStoreTrustAll );
            if ( trustAllString != null )
            {
               final Boolean trustAll = Boolean.valueOf( trustAllString );
               if ( trustAll != null )
               {
                  connection.setTrustAll( trustAll );
               }
            }

            connections.put( row.get( DataSets.Named ), connection );
         }
         catch ( final Exception ex )
         {
            LOG.log( Level.SEVERE, "Failed to convert to WebSocketConfiguration", ex );
            return null;
         }
      }
      return connections;
   }

   public static class Parameter
   {
      public static final String WebSocketUri = "websocket-uri";

      public static final String TextBufferSize = "text-buffer-size";

      public static final String BinaryBufferSize = "binary-buffer-size";

      public static final String MessageWaitTimeout = "message-wait-timeout";

      public static final String StartAfterInitialization = "start-after-initialization";

      public static final String AuthUsername = "auth-username";

      public static final String AuthPassword = "auth-password";

      public static final String AuthTimeout = "auth-timeout-ms";

      public static final String KeyStorePath = "keystore-path";

      public static final String KeyStorePassword = "keystore-password";

      public static final String KeyStoreTrustAll = "trust-all";
   }
}
