package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Button
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyCallHistoryRedialBtnLabel extends FxScriptTemplate {

    public static final String IPARAM_DISPLAY_NAME = "display_name";

    @Override
    void script() {

        String displayName = assertInput(IPARAM_DISPLAY_NAME) as String

        final Button redialCallButton = robot.lookup("#redialCallButton").queryFirst()

        String buttonText = redialCallButton.getText()

        evaluate(ExecutionDetails.create("Button displays the expected text: ", redialCallButton.getText())
                .expected("Button displays the expected text: " + displayName)
                .success(buttonText.contains(displayName)))
    }
}
