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

import org.jbehave.core.annotations.Given;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;

import scripts.cats.hmi.ClickDAButton;

public class UISteps extends AutomationSteps
{
   @Given("the test scenario using the profile $profileName")
   public void testScenario( final String profileName )
   {
      final Profile profile = assertProfile( profileName );

      evaluate( localStep( "Check profile" ).details( ExecutionDetails.create( "profile not null" ).expected( "yes" )
            .received( "no" ).usedData( "profile", profile ).success( profile != null ) ) );

      evaluate( remoteStep( "Check application status" )
            .scriptOn( profileScriptResolver().map( ClickDAButton.class, BookableProfileName.javafx ), profile ) );
   }
}
