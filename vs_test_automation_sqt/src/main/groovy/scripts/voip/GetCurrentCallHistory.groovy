package scripts.voip

import com.frequentis.c4i.test.agent.voip.phone.Phone
import com.frequentis.c4i.test.agent.voip.phone.model.CallHistory
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.cats.voip.plugin.VoIPScriptTemplate
import org.slf4j.Logger
import org.slf4j.LoggerFactory

/**
 * @author mayar
 */
class GetCurrentCallHistory extends VoIPScriptTemplate {
    private static Logger LOG = LoggerFactory.getLogger(GetCurrentCallHistory.class.getName());
    public static final String IPARAM_SIP_USERENTITIES = "sip-user-entities";
    public static final String OPARAM_CURRENT_CALLHISTORY = "call-history";

    @Override
    protected void script() {

        List<String> userEntities = assertInput(IPARAM_SIP_USERENTITIES) as List;
        Map<String, CallHistory> callCurrentCallHistory = new HashMap<>();
        for (String userEntity : userEntities) {
            Phone phone = assertPhone(userEntity);

            if (phone.getCall() != null) {
                CallHistory currentCallHistory = phone.getCurrentCallHistory()
                LOG.info("Current call history is " + currentCallHistory)
                if (currentCallHistory != null) {
                    record(
                            ExecutionDetails
                                    .create("Getting performance values of phone: " + userEntity)
                                    .receivedData("Call history", currentCallHistory)
                                    .group(userEntity)
                    );

                    callCurrentCallHistory.put(userEntity, currentCallHistory);
                }
            }
        }
        setOutput(OPARAM_CURRENT_CALLHISTORY, callCurrentCallHistory);
    }
}
