package scripts.voip

import com.frequentis.c4i.test.agent.voip.phone.Phone
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.cats.voip.dto.MediaDescriptionAttribute
import com.frequentis.cats.voip.dto.MepConfiguration
import com.frequentis.cats.voip.dto.SipContact
import com.frequentis.cats.voip.plugin.VoIPScriptTemplate
import org.slf4j.Logger
import org.slf4j.LoggerFactory

/**
 * @author mayar
 */
public class CheckIncomingSDP extends VoIPScriptTemplate {

    private static Logger LOG = LoggerFactory.getLogger(CheckIncomingSDP.class.getName());
    public static final String IPARAM_SIP_CONTACT = "sip-user-entity";
    public static final String IPARAM_MEP_CONFIG = "mep-config";

    @Override
    protected void script() {
        SipContact sipContact = assertInput(IPARAM_SIP_CONTACT) as SipContact;
        MepConfiguration mepConfiguration = assertInput(IPARAM_MEP_CONFIG) as MepConfiguration;

        Phone phone = assertPhone(sipContact.getUserEntity());

        record(ExecutionDetails.create("Check Audio Codecs")
                .received("Received codecs: " + phone.getCall().getSessionManager().getRemotePartySDP().extractAudioEncodings())
                .success(Objects.equals(phone.getCall().getSessionManager().getRemotePartySDP().extractAudioEncodings(), mepConfiguration.capabilities)));

        checkConfigVsReceived("fid", mepConfiguration, phone);
        checkConfigVsReceived("type", mepConfiguration, phone);
    }

    private void checkConfigVsReceived(
            final String headerName, final MepConfiguration mepConfiguration, final Phone phone) {
        String header = null;
        for (MediaDescriptionAttribute attribute : mepConfiguration.getSdpConfig().getMediaDescriptionAttributes()) {
            if (attribute.attributeName.equals(headerName)) {
                header = attribute.attributeValue
                phone.getCall().getSessionManager().getRemotePartySDP().getAttributes(true).each {
                    if (it.toString().contains(headerName)) {
                        record(ExecutionDetails.create("Check" + headerName)
                                .received("Received: " + it)
                                .success(it.toString().contains(header)));
                    }
                }
                phone.getCall().getSessionManager().getRemotePartySDP().getMediaDescriptionAttributes().each {
                    if (it.toString().contains(headerName)) {
                        record(ExecutionDetails.create("Check" + headerName)
                                .received("Received fid: " + it)
                                .success(it.toString().contains(header)));
                    }
                }
            };
        }

    }
}
