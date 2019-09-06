package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnIdlePopupButton extends FxScriptTemplate {

    public static final String IPARAM_BUTTON_NAME = "button_name"

    @Override
    void script() {

        String buttonName = assertInput(IPARAM_BUTTON_NAME) as String

        Node idlePopup = robot.lookup("#idlePopup").queryFirst()

        evaluate(ExecutionDetails.create("Idle popup was found")
                .expected("Idle popup is visible")
                .success(idlePopup.isVisible()))

        final Node button
        switch (buttonName) {
            case "Settings":
                button = robot.lookup("#idlePopup #openSettingPanel").queryFirst()
                break
            case "Maintenance":
                button = robot.lookup("#idlePopup #openMaintenancePanel").queryFirst()
                break
            default:
                break
        }
        evaluate(ExecutionDetails.create("Button was found")
                .expected("Button is not null")
                .success(button != null))

        robot.clickOn(robot.point(button))
    }
}
