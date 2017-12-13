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
package com.frequentis.xvp.voice.test.automation.sqt.step.local;

import java.util.List;

import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.xvp.voice.test.automation.sqt.data.NameValuePair;

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
         setStoryData( pair.getName(), pair.getValue() );
      }
   }
}
