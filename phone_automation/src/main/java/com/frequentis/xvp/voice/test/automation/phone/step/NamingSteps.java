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

import java.util.List;

import org.jbehave.core.annotations.Given;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.voice.test.automation.phone.data.CallHistoryEntry;
import com.frequentis.xvp.tools.cats.websocket.automation.model.PhoneBookEntry;

public class NamingSteps extends AutomationSteps
{
   @Given("the following phone book entries: $phoneBookEntries")
   public void namedCallParties( final List<PhoneBookEntry> phoneBookEntries )
   {
      final LocalStep localStep = localStep( "Define the phone book entries" );
      for ( final PhoneBookEntry phoneBookEntry : phoneBookEntries )
      {
         final String key = phoneBookEntry.getKey();
         setStoryListData( key, phoneBookEntry );
         localStep
               .details( ExecutionDetails.create( "Define the phone book entries" ).usedData( key, phoneBookEntry ) );
      }

      record( localStep );
   }

   @Given("the following call history entries: $callHistoryEntries")
   public void namedHistoryEntries( final List<CallHistoryEntry> callHistoryEntries )
   {
      final LocalStep localStep = localStep( "Define the call history entries" );
      for ( final CallHistoryEntry callHistoryEntry : callHistoryEntries )
      {
         final String key = callHistoryEntry.getKey();
         setStoryListData( key, callHistoryEntry );
         localStep
                 .details( ExecutionDetails.create( "Define the call history entries" ).usedData( key, callHistoryEntry ) );
      }

      record( localStep );
   }

}
