package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyDAButtonUsageNotReady extends FxScriptTemplate {
    public static final String IPARAM_DA_KEY_ID = "da_key_id"

    @Override
    void script() {
        String daKeyId = assertInput(IPARAM_DA_KEY_ID) as String

        Node daWidget = robot.lookup("#" + daKeyId).queryFirst()

        WaitTimer.pause(1000)

        evaluate(ExecutionDetails.create("Verify DA key was found")
                .expected("DA key with id " + daKeyId + " was found")
                .success(daWidget != null))

        evaluate(ExecutionDetails.create("Verify DA key is disabled")
                .expected("DA key with id " + daKeyId + " is disabled")
                .success(daWidget.isDisabled()))
    }
}
