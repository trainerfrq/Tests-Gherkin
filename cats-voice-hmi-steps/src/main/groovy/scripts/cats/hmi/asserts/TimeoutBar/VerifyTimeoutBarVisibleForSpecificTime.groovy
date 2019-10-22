package scripts.cats.hmi.asserts.TimeoutBar

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
        long checkTime = assertInput(IPARAM_TIME_SECONDS) as long

        Node timeoutBar = robot.lookup("#" + functionKeyID + " .timeoutBar").queryFirst()

        long duration = (long) 0.0
        long minElapsedTime = checkTime - 2
        long maxElapsedTime = checkTime + 2

        evaluate(ExecutionDetails.create("Searching Timeout Bar")
                .expected("Timeout Bar was found")
                .success(timeoutBar != null));

        if (timeoutBar != null) {
            if (isExistent) {
                long startTime = System.currentTimeSeconds()

                while (timeoutBar.isVisible()) {
                    duration = System.currentTimeSeconds() - startTime
                    Thread.sleep(100)
                }

                evaluate(ExecutionDetails.create("Timeout Bar was visible for duration" + duration + " seconds")
                        .expected("Timeout Bar was visible: " + isExistent)
                        .success(((minElapsedTime <= duration) && (duration <= maxElapsedTime))))
            }
        }
    }
}
