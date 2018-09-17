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
package scripts.cats.voip.parallel

import com.frequentis.c4i.test.agent.voip.phone.Phone
import com.frequentis.c4i.test.agent.voip.phone.model.sdp.SessionDescription
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.cats.voip.dto.SipContact
import com.frequentis.cats.voip.plugin.VoIPScriptTemplate
import gov.nist.javax.sdp.fields.AttributeField

/**
 * Check the SDP rtpMap on the remote side SDP.
 */
class CheckSDPRtpMapOnSIPRequest extends VoIPScriptTemplate {

    public static final String IPARAM_SIP_CONTACTS = "sip-contacts";

    public static final String IPARAM_CODEC_PARAM = "codec-param";


    @Override
    protected void script() {
        List<SipContact> sipContacts = assertInput(IPARAM_SIP_CONTACTS) as List

        String codecParam = getInput(IPARAM_CODEC_PARAM) as String

        for (SipContact sipContact : sipContacts) {
            Phone phone = assertPhone(sipContact.getUserEntity())

            List<String> requiredCodecs = codecParam.split(",").toList()

            List<String> receivedCodecs = new ArrayList<>()

            Optional<SessionDescription> sessionDescription = phone.getCall().getParent().getSessionManager().getReceivedRemoteSdp()

            if (sessionDescription.isPresent()) {
                evaluate(ExecutionDetails.create("Received SDP")
                        .received("Received SDP:" + sessionDescription.toString())
                        .success())

                Vector<AttributeField> atrField = sessionDescription.get().getMediaDescriptionAttributes()
                for (AttributeField af : atrField) {
                    if (af.getName() == "rtpmap") {
                        receivedCodecs.add(af.getValue());
                    }
                }
            }

            for (String codec : requiredCodecs) {
                evaluate(ExecutionDetails.create("Check rtpmap on SDP:")
                        .expected("Expected Codec:\n" + codec)
                        .received("Received Codecs:\n" + receivedCodecs.join("\n"))
                        .success(receivedCodecs.contains(codec.trim())))
            }
        }
    }
}
