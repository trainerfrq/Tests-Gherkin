package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnIdleWarningPopupButton extends FxScriptTemplate {

    public static final String IPARAM_BUTTON_NAME= "button_name"

    @Override
    void script() {

        String buttonName = assertInput(IPARAM_BUTTON_NAME) as String

        Node unattendedPopup = robot.lookup("#unattendedPopup").queryFirst()

        evaluate(ExecutionDetails.create("Unattended popup was found")
                .expected("Unattended popup is not null")
                .success(unattendedPopup != null))

        final Node button
        switch(buttonName)
            {
                case "Ok":
                    button = robot.lookup("#unattendedPopup #requestIdleState").queryFirst()
                    break
                case "Stay operational":
                    button = robot.lookup("#unattendedPopup #stayOperationButton").queryFirst()
                    break
                default:
                    break
        }
        robot.clickOn(robot.point(button))
    }
}
