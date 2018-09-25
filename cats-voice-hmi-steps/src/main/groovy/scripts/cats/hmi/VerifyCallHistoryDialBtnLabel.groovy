package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Button
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyCallHistoryDialBtnLabel extends FxScriptTemplate {

    public static final String IPARAM_DISPLAY_NAME = "display_name";

    @Override
    void script() {

        String displayName = assertInput(IPARAM_DISPLAY_NAME) as String

        final Button dialCallButton = robot.lookup("#initiateCallButton").queryFirst()

        String buttonText = dialCallButton.getText()

        evaluate(ExecutionDetails.create("Button displays the expected text: ", dialCallButton.getText())
                .expected("Button displays the expected text: " + displayName)
                .success(buttonText.contains(displayName)))
    }
}
