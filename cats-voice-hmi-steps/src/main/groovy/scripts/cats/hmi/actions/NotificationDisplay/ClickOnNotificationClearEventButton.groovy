package scripts.cats.hmi.actions.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class ClickOnNotificationClearEventButton extends FxScriptTemplate {

    @Override
    void script() {

        Node clearEventListButton = robot.lookup("#clearEventListButton").queryFirst()

        evaluate(ExecutionDetails.create("Clear Event list button was found")
                .expected("Clear Event list button exits")
                .success(clearEventListButton != null))

        robot.clickOn(robot.point(clearEventListButton))
    }
}
