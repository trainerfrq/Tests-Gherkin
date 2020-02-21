package scripts.cats.hmi.actions.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class ClickOnNotificationTab extends FxScriptTemplate {

    public static final String IPARAM_TAB_NAME= "tab_name"

    @Override
    void script() {

        String tabName = assertInput(IPARAM_TAB_NAME) as String

        Node tab = robot.lookup("#"+tabName+"HeaderTab").queryFirst()

        evaluate(ExecutionDetails.create("Notification list tab "+ tabName+" was found")
                .expected("Notification list tab "+ tabName+" exits")
                .success(tab != null))

        robot.clickOn(robot.point(tab))
    }
}

