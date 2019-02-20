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
package com.frequentis.xvp.voice.test.automation.phone.step;

import scripts.cats.websocket.sequential.SendTextMessage;

import java.util.ArrayList;
import java.util.List;

import org.jbehave.core.annotations.Then;

import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.audio.ChangedEventCommand;
import com.frequentis.xvp.tools.cats.websocket.automation.model.ProfileToWebSocketConfigurationReference;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.tools.cats.websocket.dto.WebsocketAutomationSteps;
import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.signalling.InputSignalChangedEvent;
import com.google.gson.Gson;

public class AudioSteps extends WebsocketAutomationSteps
{

   @Then("$namedWebSocket sends changed event request - $action headsets")
   public void sendChangeEvent( final String namedWebSocket, final String action )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );
      List<InputSignalChangedEvent> inputSignals = new ArrayList<>(  );

      switch(action){
         case "disconnect":
            inputSignals.add( InputSignalChangedEvent.builder().withSignalId( "Op1Att" ).withState( 0 ).build() );
            inputSignals.add( InputSignalChangedEvent.builder().withSignalId( "Co1Att" ).withState( 0 ).build() );
            break;
         case "reconnect":
            inputSignals.add( InputSignalChangedEvent.builder().withSignalId( "Op1Att" ).withState( 1 ).build() );
            inputSignals.add( InputSignalChangedEvent.builder().withSignalId( "Co1Att" ).withState( 1 ).build() );
            break;
         default:
            evaluate( localStep( "Check action on headsets" )
                  .details( ExecutionDetails.create( "Unknown action: " + action ).failure() ) );
            break;
      }
      String request = new Gson().toJson( new ChangedEventCommand( inputSignals ) );

      evaluate( remoteStep( "Sending sends changed event request - disconnect headsets " )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendTextMessage.IPARAM_MESSAGETOSEND, request ) );
   }
}
