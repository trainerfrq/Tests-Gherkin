package scripts.cats.hmi.asserts.DAKey

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyDAKeyTimeoutBar extends FxScriptTemplate {
    public static final String IPARAM_DA_KEY_ID = "da_key_id"
    public static final String IPARAM_IS_VISIBLE = "is_visible"

    @Override
    void script() {
        String daKeyId = assertInput(IPARAM_DA_KEY_ID) as String
        Boolean isVisible = assertInput(IPARAM_IS_VISIBLE) as Boolean

        Node daWidget = robot.lookup("#" + daKeyId + " #callIntrusion").queryFirst()

        if (isVisible) {
            evaluate(ExecutionDetails.create("Verify DA Key " + daKeyId + " Timeout bar")
                    .expected("Timeout bar is visible: " + isVisible)
                    .success(daWidget.isVisible()))
        } else {
            evaluate(ExecutionDetails.create("Verify DA Key " + daKeyId + " Timeout bar")
                    .expected(daWidget.getClass().toString() + "Timeout bar "+daWidget.isVisible().toString() + " is visible: " + isVisible)
                    .success(!(daWidget.isVisible())))
        }
    }
}
