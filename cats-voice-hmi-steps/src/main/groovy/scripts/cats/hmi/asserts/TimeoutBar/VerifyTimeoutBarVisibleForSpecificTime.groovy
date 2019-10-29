package scripts.cats.hmi.asserts.TimeoutBar

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyTimeoutBarVisibleForSpecificTime extends FxScriptTemplate {

    public static final String IPARAM_FUNCTION_KEY_ID = "id_functionKey"
    public static final String IPARAM_TIME_SECONDS = "check_time"

    @Override
    void script() {
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
            long startTime = System.currentTimeSeconds()

            while (timeoutBar.isVisible()) {
                duration = System.currentTimeSeconds() - startTime
                Thread.sleep(100)
            }

            evaluate(ExecutionDetails.create("Timeout Bar was visible for " + duration + " seconds")
                    .expected("Timeout Bar was visible")
                    .success(((minElapsedTime <= duration) && (duration <= maxElapsedTime))))
        }
    }
}
