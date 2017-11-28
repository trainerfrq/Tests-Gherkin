/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.tools.cats.websocket.automation.steps;

import scripts.cats.websocket.sequential.buffer.OpenBuffer;

import org.jbehave.core.annotations.When;

import com.frequentis.xvp.tools.cats.websocket.automation.model.ProfileToWebSocketConfigurationReference;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.tools.cats.websocket.dto.WebsocketAutomationSteps;

public class VoiceBaseSteps extends WebsocketAutomationSteps
{
   @When("$namedWebSocket opens the Missions Available buffer named $bufferName")
   public void openMissionsAvailableIndicationBuffer( final String namedWebSocket, final String bufferName )
   {
      openCustomBuffer( namedWebSocket, bufferName, "missionsAvailableIndication" );
   }


   private void openCustomBuffer( final String namedWebSocket, final String bufferName, final String messageType )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      evaluate( remoteStep( "Create the buffer named: " + bufferName + " with filter type: " + messageType )
            .scriptOn( profileScriptResolver().map( OpenBuffer.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( OpenBuffer.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( OpenBuffer.IPARAM_BUFFERKEY, bufferName ).input( OpenBuffer.IPARAM_MESSAGETYPE, messageType ) );
   }
}
