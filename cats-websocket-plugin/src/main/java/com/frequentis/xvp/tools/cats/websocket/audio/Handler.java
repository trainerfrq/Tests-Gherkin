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
import com.frequentis.xvp.voice.audiointerface.json.messages.JsonMessage;
import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.signalling.EpLogicSignalChangedEvent;
import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.signalling.InputSignalChangedEvent;
import com.google.gson.Gson;
import org.eclipse.jetty.websocket.api.RemoteEndpoint;

import java.io.IOException;
import java.util.List;

public class Handler extends DefaultWebSocketAdapterIOListener
{
   @Override
   public void onWebSocketText( final TextMessage textMessage )
   {
      ChangedEventCommand evCommand = new Gson()
            .fromJson( textMessage.getContent(),ChangedEventCommand.class );

      sendEpLogicSignalChangedEvent( AudioHandler.getSession().getRemote(), evCommand.getInputSignals() );
   }


   public static void sendEpLogicSignalChangedEvent( final RemoteEndpoint endpoint,
         final List<InputSignalChangedEvent> inputSignals )
   {
      JsonMessage event = JsonMessage.builder()
            .withEpLogicSignalChangedEvent(
                  EpLogicSignalChangedEvent.builder().withInputSignals( inputSignals ).build() ).build();
      try
      {
         endpoint.sendString( event.toString() );
      }
      catch ( IOException e )
      {
         e.printStackTrace();
      }
   }
}
