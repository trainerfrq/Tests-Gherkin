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
import com.frequentis.xvp.tools.cats.websocket.automation.model.CallParty;

public class NamingSteps extends AutomationSteps
{
   @Given("the following call parties: $callParties")
   public void namedCallParties( final List<CallParty> callParties )
   {
      final LocalStep localStep = localStep( "Define the call parties" );
      for ( final CallParty callParty : callParties )
      {
         final String key = callParty.getKey();
         setStoryListData( key, callParty );
         localStep.details( ExecutionDetails.create( "Define the call parties" ).usedData( key, callParty ) );
      }

      record( localStep );
   }

}
