package scripts.cats.hmi.asserts.DAKey

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyDAKeyLabel extends FxScriptTemplate {

    public static final String IPARAM_DA_KEY_ID = "da_key_id"
    public static final String IPARAM_DA_KEY_CALL_TYPE = "da_key_call_type"
    public static final String IPARAM_LABEL_TYPE = "label_type"

    @Override
    void script() {

        String daKeyId = assertInput(IPARAM_DA_KEY_ID) as String
        String daKeyCallType = assertInput(IPARAM_DA_KEY_CALL_TYPE) as String
        String labelType = assertInput(IPARAM_LABEL_TYPE) as String

        Label label = robot.lookup("#" + daKeyId + " #"+labelType+"Label").queryFirst()
        String typeText = label.getText()
        evaluate(ExecutionDetails.create("Verify DA key display call type")
                .expected(daKeyCallType)
                .received(typeText)
                .success(typeText == daKeyCallType))
    }
}
