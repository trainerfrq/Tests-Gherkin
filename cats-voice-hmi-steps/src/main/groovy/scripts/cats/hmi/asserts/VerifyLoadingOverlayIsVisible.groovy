package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyLoadingOverlayIsVisible extends FxScriptTemplate {

    @Override
    void script() {

        Node loadingOverlay = robot.lookup("#loadingOverlay").queryFirst();

        WaitTimer.pause(1000);

        evaluate(ExecutionDetails.create("Verify loading overlay was found")
                .expected("Screen " + loadingOverlay + " was found")
                .success(loadingOverlay != null));

    }
}
