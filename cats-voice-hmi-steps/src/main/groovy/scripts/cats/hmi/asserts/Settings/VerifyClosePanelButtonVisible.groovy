package scripts.cats.hmi.asserts.Settings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyClosePanelButtonVisible extends FxScriptTemplate {

    public static final String IPARAM_BUTTON_NUMBER= "number"

    @Override
    void script() {

        Integer buttonNumber = assertInput(IPARAM_BUTTON_NUMBER) as Integer

        Node button = robot.lookup("#closePanelButton_" + buttonNumber).queryFirst()

        evaluate(ExecutionDetails.create("Button was found")
                .expected("Button is visible")
                .success(button.isVisible()))
    }

}