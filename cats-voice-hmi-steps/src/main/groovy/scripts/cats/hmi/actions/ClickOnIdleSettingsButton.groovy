package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnIdleSettingsButton extends FxScriptTemplate {

    public static final String IPARAM_BUTTON_NAME= "button_name"

    @Override
    void script() {

        String buttonName = assertInput(IPARAM_BUTTON_NAME) as String

        Node idlePopup = robot.lookup("#idlePopup").queryFirst()

        evaluate(ExecutionDetails.create("Idle popup was found")
                .expected("Idle popup is not null")
                .success(idlePopup != null))

        final Node button
        switch(buttonName)
        {
            case "Settings":
                button = robot.lookup("#idlePopup #openSettingPanel").queryFirst()
                break
            case "Maintenance":
                button = robot.lookup("#idlePopup #openMaintenancePanel").queryFirst()
                break
            default:
                break
        }
        robot.clickOn(robot.point(button))
    }
}
