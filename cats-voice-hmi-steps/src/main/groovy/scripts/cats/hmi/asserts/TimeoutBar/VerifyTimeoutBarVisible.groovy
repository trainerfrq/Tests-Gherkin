package scripts.cats.hmi.asserts.TimeoutBar

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyTimeoutBarVisible extends FxScriptTemplate {

    public static final String IPARAM_FUNCTION_KEY_ID = "id_functionKey"
    public static final String IPARAM_IS_VISIBLE = "is_visible"

    @Override
    void script() {
        Boolean isExistent = assertInput(IPARAM_IS_VISIBLE) as Boolean
        String functionKeyID = assertInput(IPARAM_FUNCTION_KEY_ID) as String

        Node timeoutBar = robot.lookup("#" + functionKeyID + " .timeoutBar").queryFirst()

        evaluate(ExecutionDetails.create("Searching Timeout Bar")
                .expected("Timeout Bar was found")
                .success(timeoutBar != null))

        if (isExistent) {
            evaluate(ExecutionDetails.create("Timeout Bar is visible")
                    .expected("Timeout Bar is visible: " + isExistent)
                    .success(timeoutBar.isVisible()))
        } else {
            evaluate(ExecutionDetails.create("Timeout Bar is not visible")
                    .expected("Timeout Bar is visible: " + isExistent)
                    .success(!timeoutBar.isVisible()))
        }
    }
}
