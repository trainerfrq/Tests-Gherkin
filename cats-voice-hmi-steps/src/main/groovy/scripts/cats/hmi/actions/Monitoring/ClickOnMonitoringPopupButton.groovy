package scripts.cats.hmi.actions.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnMonitoringPopupButton extends FxScriptTemplate {

    public static final String IPARAM_BUTTON_NAME = "button_name"

    @Override
    void script() {

        String buttonName = assertInput(IPARAM_BUTTON_NAME) as String

        Node monitoringPopup = robot.lookup("#monitoringPopup").queryFirst()

        evaluate(ExecutionDetails.create("Monitoring popup was found")
                .expected("Monitoring popup is visible")
                .success(monitoringPopup.isVisible()))

        if (monitoringPopup.isVisible()) {
            final Node button = robot.lookup("#" + buttonName +"Button").queryFirst()

            robot.clickOn(robot.point(button))
        }
    }
}

