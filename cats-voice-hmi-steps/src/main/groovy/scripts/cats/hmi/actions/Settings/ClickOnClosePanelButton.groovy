package scripts.cats.hmi.actions.Settings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class ClickOnClosePanelButton extends FxScriptTemplate {

    public static final String IPARAM_BUTTON_NUMBER= "button_number"

    @Override
    void script() {

        Integer buttonNumber = assertInput(IPARAM_BUTTON_NUMBER) as Integer

        Node button = robot.lookup("#closePanelButton_" + buttonNumber).queryFirst()

        evaluate(ExecutionDetails.create("Button was found")
                .expected("Button is not null")
                .success(button.isVisible()))

        robot.clickOn(robot.point(button))
    }

}
