package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Button
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyCallHistoryDialButtonLabel extends FxScriptTemplate {

    public static final String IPARAM_DISPLAY_NAME = "display_name";

    @Override
    void script() {

        String displayName = assertInput(IPARAM_DISPLAY_NAME) as String

        final Button dialCallButton = robot.lookup("#initiateCallButton").queryFirst()

        String buttonText = dialCallButton.getText()

        evaluate(ExecutionDetails.create("Button displays the expected text ")
                .expected("Button displays the expected text: " + displayName)
                .received("Button displays the expected text: " + buttonText)
                .success(buttonText.contains(displayName)))
    }
}
