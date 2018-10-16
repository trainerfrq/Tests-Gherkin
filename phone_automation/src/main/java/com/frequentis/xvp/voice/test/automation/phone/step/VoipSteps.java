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

import org.apache.commons.lang3.StringUtils;
import org.jbehave.core.annotations.Then;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStep;
import com.frequentis.c4i.test.bdd.instrumentation.model.EndpointConfigMapping;
import com.frequentis.cats.voip.dto.SipContact;

import org.jbehave.core.annotations.When;
import scripts.cats.voip.parallel.CheckSDPRtpMapOnSIPRequest;
import scripts.cats.voip.parallel.EstablishAndMoveCall;

import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

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

    @When(value = "$callerGroup tries to establish call to SIP URI $sipUri", priority = 1)
    public void initiateAndMoveCall(final EndpointConfigMapping<SipContact> callerGroup, final String sipUri) {
        Map<Profile, HashMap<SipContact, String>> callerCalleeMapPerProfile = getCallTargetMappingPerProfile(
                callerGroup, Collections.singletonList(sipUri), null);
        establishAndMoveCalls(callerCalleeMapPerProfile);
    }

    private Map<Profile, HashMap<SipContact, String>> getCallTargetMappingPerProfile(
            final EndpointConfigMapping<SipContact> callerGroup, final List<String>
            callTargets, final String replaceCalleeHost) {
        Map<Profile, HashMap<SipContact, String>> callerCalleeMapPerProfile = new HashMap<>();
        Iterator<String> calleeIterator = null;

        // Iterate callers per profile and assign callees.
        for (final Profile callerProfile : callerGroup.getProfiles()) {
            // Validate if already a caller-callee mapping for the current profile of the caller group exists, otherwise create a new map.
            HashMap<SipContact, String> callerCalleeMapForProfile = callerCalleeMapPerProfile.get(callerProfile);
            if (callerCalleeMapForProfile == null) {
                callerCalleeMapForProfile = new HashMap<>();
                callerCalleeMapPerProfile.put(callerProfile, callerCalleeMapForProfile);
            }

            // Iterate all callers and try to find a callee.
            for (final SipContact caller : callerGroup.getEndpointConfigs(callerProfile)) {
                // Reset callee iterator if not yet instantiated or no more callee SipContacts left.
                if (calleeIterator == null || !calleeIterator.hasNext()) {
                    calleeIterator = callTargets.iterator();
                }

                String callee = calleeIterator.next();

                // Replace host part if value is provided.
                if (StringUtils.isNotBlank(replaceCalleeHost)) {
                    String userPart = callee.substring(0, callee.indexOf("@"));
                    callee = userPart + "@" + replaceCalleeHost;
                }

                callerCalleeMapForProfile.put(caller, callee);
            }
        }

        return callerCalleeMapPerProfile;
    }

    private void establishAndMoveCalls(final Map<Profile, HashMap<SipContact, String>> callerCalleeMapPerProfile) {
        RemoteStep remoteStep = remoteStep("Establish and move call");
        for (Map.Entry<Profile, HashMap<SipContact, String>> mapEntry : callerCalleeMapPerProfile.entrySet()) {
            Profile profile = mapEntry.getKey();
            HashMap<SipContact, String> callerCallTargetMapping = mapEntry.getValue();

            remoteStep.scriptOn(EstablishAndMoveCall.class, profile)
                    .input(EstablishAndMoveCall.IPARAM_CALLER_CALLEE_MAPPING, callerCallTargetMapping)
                    .input(EstablishAndMoveCall.IPARAM_CALL_SHELL_BE_ESTABLISED, false);
        }

        evaluate(remoteStep);
    }

}
