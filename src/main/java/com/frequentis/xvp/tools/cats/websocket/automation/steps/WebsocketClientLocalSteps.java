/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.tools.cats.websocket.automation.steps;

import java.util.ArrayList;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.slf4j.LoggerFactory;

import com.frequentis.c4i.test.agent.websocket.client.impl.models.ClientEndpointConfiguration;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;
import com.frequentis.xvp.tools.cats.websocket.dto.WebsocketAutomationSteps;

/**
 * Created by MAyar on 18.01.2017.
 */
public class WebsocketClientLocalSteps extends WebsocketAutomationSteps
{
   private static final org.slf4j.Logger LOG = LoggerFactory.getLogger( WebsocketClientLocalSteps.class.getName() );

   private static final Integer ZERO_PADDING_FLAG_AND_WIDTH_START_INDEX = 3;


   @Given("named the websocket configurations: $connections")
   public void namedWebSocketClientConnection( final Map<String, ClientEndpointConfiguration> connections )
   {
      LOG.info( "Connections: " + connections );
      final LocalStep step = localStep( "Added named websocket client configurations to user named parameters" );
      int count = 1;
      for ( final Map.Entry<String, ClientEndpointConfiguration> connectionsEntry : connections.entrySet() )
      {
         final String key = connectionsEntry.getKey();
         final ClientEndpointConfiguration config = connectionsEntry.getValue();
         setStoryListData( key, config );
         step.details( ExecutionDetails.create( "Parse data table. Entry " + count + " of " + connections.size() )
               .expected( "ExamplesTable can be parsed" ).receivedData( key, config ).success( true ) );
         count++;
      }
      evaluate( step );
   }


   @Then("wait for $secs seconds")
   public void waitForSeconds( final int secs )
   {
      final LocalStep step = localStep( "Wait for " + secs + " seconds" );

      try
      {
         Thread.sleep( secs * 1000 );
         step.details(
               ExecutionDetails.create( "Wait for " + secs + " seconds" ).received( "Waited" ).success( true ) );
      }
      catch ( final Exception ex )
      {
         LOG.error( "Error", ex );
         step.details( ExecutionDetails.create( "Wait for " + secs + " seconds" ).received( "Waited with error" )
               .success( false ) );
      }
      record( step );
   }


   @Given("The $namedParameter is defined as $value")
   public void setNamedParameter( final String namedParameter, final String value )
   {
      final LocalStep setNamedParameter = localStep( "Named Parameter" );

      setStoryListData( namedParameter, value );

      setNamedParameter.details( ExecutionDetails.create( "Parameter named" ).usedData( namedParameter, value ) );
   }


   /*
   
   | key                                                                                                                                 |
   | {"header": {"correlationId": "00004711-0815-4000-8000-00000000021<%i>"}, "body": {"statisticRequest": { "sessionId": "ID<%i>"}}}    |
   
   */

   @Given("$amount messages created in group $group with varaible field with value starting from $startIndex : $messages")
   public void createNamedParameter( final Integer amount, final String group, final Integer startIndex,
         final ArrayList<CatsCustomParameterBase> messages )
   {
      final LocalStep createNamedParameter = localStep( "Creating named group" );

      final ArrayList<String> messageList = new ArrayList<>();
      final ArrayList<String> finalMessageList = new ArrayList<>();
      for ( final CatsCustomParameterBase parameter : messages )
      {
         final String message = parameter.getKey();
         LOG.info( "message is " + message );
         messageList.add( message );

      }

      for ( int i = startIndex; i <= amount + startIndex; i++ )
      {
         LOG.info( "messageList is : " + messageList );
         for ( final String message : messageList )
         {
            finalMessageList.add( replaceIndex( message, i ) );
         }
      }

      setStoryListData( group, finalMessageList );
      createNamedParameter.details( ExecutionDetails.create( "Group created" ).usedData( group, finalMessageList ) );

   }


   /*{"header": {"correlationId": "00004711-0815-4000-8000-00000000021a"}, "body": {"statisticRequest": { "<sessionId>"}}}*/

   @Given("the $namedMessage is defined with variable $variable as $value")
   public void createVariableParameter( final String namedMessage, final String param, final String value )
   {
      if ( getStoryListData( param, String.class ) != null )
      {
         setStoryListData( namedMessage,
               value.replaceAll( param.split( ":" )[0], getStoryListData( param, String.class ) ) );
      }
      else
      {
         setStoryListData( namedMessage, value.replaceAll( param.split( ":" )[0], param ) );
      }
   }


   private String replaceIndex( final String stringValue, final Integer replaceIndex )
   {
      String output = stringValue;

      // <%i[0-9]*> matches values like <%i>, <%i2>, <%i03>.
      final Matcher matcher = Pattern.compile( "<%i[0-9]*>" ).matcher( stringValue );
      boolean anyMatch = false;
      while ( matcher.find() )
      {
         anyMatch = true;
         final String matchedString = stringValue.substring( matcher.start(), matcher.end() );

         // E.g.: 2 means: The target width is 2.
         // E.g.: 02 means: 0 indicates a zero-padding and 2 indicates the width.
         final String zeroPaddingFlagAndWidth =
               matchedString.substring( ZERO_PADDING_FLAG_AND_WIDTH_START_INDEX, matchedString.length() - 1 );

         final String index = String.format( "%" + zeroPaddingFlagAndWidth + "d", replaceIndex );
         output = output.replace( matchedString, index );
      }

      if ( !anyMatch )
      {
         // If the string value did not contain any replace indicator, the index will be added to the end of the string.
         output += replaceIndex;
      }

      return output;
   }
}
