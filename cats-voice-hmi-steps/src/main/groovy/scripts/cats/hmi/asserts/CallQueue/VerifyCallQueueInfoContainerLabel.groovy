package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueInfoContainerLabel extends FxScriptTemplate {

    public static final String IPARAM_INFO_LABEL = "info_label";

    @Override
    void script() {

        String infoLabel = assertInput(IPARAM_INFO_LABEL) as String

        Label callQueueInfoLabel = robot.lookup("#callQueueInfoContainer #infoLabel").queryFirst()

        evaluate(ExecutionDetails.create("Assert call queue info label")
                .expected("Call queue info expected is: " + infoLabel)
                .received("Call queue info received is: " + callQueueInfoLabel.getText())
                .success(callQueueInfoLabel.getText().contains(infoLabel)))


    }
}
