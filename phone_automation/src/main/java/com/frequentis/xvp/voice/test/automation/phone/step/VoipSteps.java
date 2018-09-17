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

import org.jbehave.core.annotations.Then;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStep;
import com.frequentis.c4i.test.bdd.instrumentation.model.EndpointConfigMapping;
import com.frequentis.cats.voip.dto.SipContact;

import scripts.cats.voip.parallel.CheckSDPRtpMapOnSIPRequest;

public class VoipSteps extends AutomationSteps
{
   @Then("$sipContactGroup receives $codecParam within rtpMap of the SDP received in SIP INVITE message")
   public void checkSDPOnSipRequest( final EndpointConfigMapping<SipContact> sipContactGroup, final String codecParam )
   {
      RemoteStep remoteStep = remoteStep( "Check codec within rtpMap of the the SDIp in SIP INVITE" );
      for ( final Profile profile : sipContactGroup.getProfiles() )
      {
         remoteStep.scriptOn( CheckSDPRtpMapOnSIPRequest.class, profile )
               .input( CheckSDPRtpMapOnSIPRequest.IPARAM_SIP_CONTACTS, sipContactGroup.getEndpointConfigs( profile ) )
               .input( CheckSDPRtpMapOnSIPRequest.IPARAM_CODEC_PARAM, codecParam );
      }

      evaluate( remoteStep );
   }

}
