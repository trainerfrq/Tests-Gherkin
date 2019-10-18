package scripts.cats.hmi.asserts.ForwardCall

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyTimeoutBarVisibleForSpecificTime extends FxScriptTemplate {

    public static final String IPARAM_FUNCTION_KEY_ID = "id_functionKey"
    public static final String IPARAM_TIME_SECONDS = "check_time"
    public static final String IPARAM_IS_VISIBLE = "is_visible";

    @Override
    void script() {
        Boolean isExistent = assertInput(IPARAM_IS_VISIBLE) as Boolean;
        String functionKeyID = assertInput(IPARAM_FUNCTION_KEY_ID) as String
        long checkkTime = assertInput(IPARAM_TIME_SECONDS) as long

        Node timeoutBar = robot.lookup("#" + functionKeyID + " .timeoutBar").queryFirst()

        evaluate(ExecutionDetails.create("Searching Timeout Bar")
                .expected("Timeout Bar was found")
                .success(timeoutBar != null));

        if (timeoutBar != null) {
            if (isExistent) {
                long desiredTime = System.currentTimeSeconds() + checkkTime
                boolean visibilityFlag = true;
                while (System.currentTimeSeconds() < desiredTime) {
                    if (!timeoutBar.isVisible()) {
                        visibilityFlag = false;
                        break;
                    }
                    Thread.sleep(100);
                }

                if (visibilityFlag) {
                    evaluate(ExecutionDetails.create("Timeout Bar was visible for " + checkkTime + " seconds")
                            .expected("Timeout Bar was visible: " + visibilityFlag)
                            .success(timeoutBar.isVisible()));
                }
                else {
                    evaluate(ExecutionDetails.create("Timeout Bar wasn't visible for " + checkkTime + " seconds")
                            .expected("Timeout Bar was visible: " + visibilityFlag)
                            .success(timeoutBar.isVisible()));
                }
            }
        }
    }
}
