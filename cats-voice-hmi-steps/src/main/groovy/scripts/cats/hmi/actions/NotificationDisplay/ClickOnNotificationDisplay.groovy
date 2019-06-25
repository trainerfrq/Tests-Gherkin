package scripts.cats.hmi.actions.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnNotificationDisplay extends FxScriptTemplate {

    @Override
    void script() {

        Node notificationDisplay = robot.lookup("#notificationDisplay #notificationContainer").queryFirst()

        evaluate(ExecutionDetails.create("Notification display was found")
                .expected("Notification display is not null")
                .success(notificationDisplay != null))

        robot.clickOn(robot.point(notificationDisplay))
    }
}

