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
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.DAKey;

import scripts.cats.hmi.ClickDAButton;
import scripts.cats.hmi.VerifyDAButtonState;

public class UISteps extends AutomationSteps
{
   @Given("the DA keys: $daKeys")
   public void defineDaKeys( final List<DAKey> daKeys )
   {
      final LocalStep localStep = localStep( "Define DA keys" );
      for ( final DAKey daKey : daKeys )
      {
         final String key = daKey.getSource() + "-" + daKey.getTarget();
         setStoryListData( key, daKey );
         localStep.details( ExecutionDetails.create( "Define DA key" ).usedData( key, daKey ) );
      }

      record( localStep );
   }


   @When("$profileName presses DA key for $target")
   public void clickDA( final String profileName, final String target )
   {
      DAKey daKey = retrieveDaKey( profileName, target );

      evaluate( remoteStep( "Check application status" )
            .scriptOn( profileScriptResolver().map( ClickDAButton.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( ClickDAButton.IPARAM_DA_KEY_ID, daKey.getId() ) );
   }


   @Then("$profileName has the DA key for $target in state $state")
   public void verifyDAState( final String profileName, final String target, final String state )
   {
      DAKey daKey = retrieveDaKey( profileName, target );

      evaluate( remoteStep( "Check application status" )
            .scriptOn( profileScriptResolver().map( VerifyDAButtonState.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyDAButtonState.IPARAM_DA_KEY_ID, daKey.getId() )
            .input( VerifyDAButtonState.IPARAM_DA_KEY_STATE, state ) );
   }


   private DAKey retrieveDaKey( final String source, final String target )
   {
      final DAKey daKey = getStoryListData( source + "-" + target, DAKey.class );
      evaluate( localStep( "Check DA key" ).details( ExecutionDetails.create( "Verify DA key is defined" )
            .usedData( "source", source ).usedData( "target", target ).success( daKey != null ) ) );
      return daKey;
   }
}
