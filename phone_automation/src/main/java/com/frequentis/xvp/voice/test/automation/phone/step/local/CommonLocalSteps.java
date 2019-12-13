/************************************************************************
 ** PROJECT:   XVP
 ** LANGUAGE:  Java JDK 1.8
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
package com.frequentis.xvp.voice.test.automation.phone.step.local;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.voice.test.automation.phone.data.NameValuePair;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import java.util.List;

/**
 * @author mayar
 */
public class CommonLocalSteps extends AutomationSteps
{
   @When("define values in story data: $pairs")
   public void defineValuesInStoryData( final List<NameValuePair> pairs )
   {
      for ( NameValuePair pair : pairs )
      {
         setStoryListData( pair.getName(), pair.getValue() );
      }
   }

   @Then("waiting until the cleanup is done")
   public void wait1Millisecond(){
       LocalStep step = localStep("Wait for 1 millisecond");
       try {
           Thread.sleep(1);
           step.details(ExecutionDetails.create("Wait for 1 millisecond")
                   .expected("Waited")
                   .success(true));
       } catch (InterruptedException ex) {
           step.details(ExecutionDetails.create("Wait for 1 millisecond")
                   .expected("Waited with error")
                   .success(true));
       }
       evaluate(step);
   }
}
