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

import java.util.List;

import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.signalling.InputSignalChangedEvent;

public class ChangedEventCommand
{

   private List<InputSignalChangedEvent> inputSignals;


   public ChangedEventCommand(
         final List<InputSignalChangedEvent> inputSignals )
   {
      this.inputSignals = inputSignals;
   }


   public List<InputSignalChangedEvent> getInputSignals()
   {
      return inputSignals;
   }


   @Override
   public String toString()
   {
      return "ChangedEventCommand{" +
            "inputSignals=" + inputSignals +
            '}';
   }
}
