package scripts.cats.hmi.asserts.CallHistory

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyCallHistoryDialButtonLabel extends FxScriptTemplate {

    public static final String IPARAM_DISPLAY_NAME = "display_name"

    @Override
    void script() {

        String displayName = assertInput(IPARAM_DISPLAY_NAME) as String

        final Label callButton = robot.lookup("#callHistoryPopup #initiateCallLabel").queryFirst()

        evaluate(ExecutionDetails.create("Button displays the expected text ")
                .expected("Button displays the expected text: " + displayName)
                .received("Button displays the expected text: " + callButton.getText())
                .success(callButton.getText().contains(displayName)))
    }
}
