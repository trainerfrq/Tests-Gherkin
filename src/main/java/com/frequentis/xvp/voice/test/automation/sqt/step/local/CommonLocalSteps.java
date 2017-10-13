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

import org.jbehave.core.annotations.Then;

import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.metrics.CatsMetricsStore;
import com.frequentis.c4i.test.metrics.Measurement;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.voice.test.automation.sqt.step.SystemTestingAutomationSteps;

/**
 * @author mayar
 */
public class CommonLocalSteps extends SystemTestingAutomationSteps
{
   @Then("calculated $delay from nanos $namedNanoTimeStamp1 to $namedNanoTimeStamp2 is within $milliSeconds ms and saved to DB $dbName")
   public void calculateDelayfromTimeStamps( final String delay, final String namedTimeStamp1,
         final String namedTimeStamp2, final long timeoutMs, final String dbName )
   {
      final LocalStep calculateDelay = localStep( "Calculating delay" );
      final long timeStamp1 = assertStoryListData( namedTimeStamp1, Long.class );
      final long timeStamp2 = assertStoryListData( namedTimeStamp2, Long.class );
      final long delayValue = (timeStamp1 - timeStamp2) / 1000000;

      calculateDelay.details( ExecutionDetails.create( "Calculating delay" ).usedData( namedTimeStamp1, timeStamp1 )
            .usedData( namedTimeStamp2, timeStamp2 ).received( Long.toString( delayValue ) )
            .success( delayValue > 0 && delayValue < timeoutMs ) );
      setStoryListData( delay, delayValue );
      CatsMetricsStore.getMetricsInstance()
            .reportMeasurement( Measurement.measurement( dbName ).field( delay, delayValue ).build() );

      record( calculateDelay );
   }
}
