package scripts.cats.hmi.actions.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

/**
 * @author dindre
 */
class ClickOnNotificationScrollDownButton extends FxScriptTemplate {

    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {

        String listName = assertInput(IPARAM_LIST_NAME) as String

        Node notificationPopup = robot.lookup("#notificationPopup").queryFirst()

        evaluate(ExecutionDetails.create("Notification popup was found")
                .expected("Notification popup is visible")
                .success(notificationPopup.isVisible()))

        if (notificationPopup.isVisible()) {
            final Node scrollDownButton = robot.lookup("#notificationPopup #scrollDown"+listName+"List").queryFirst()

            robot.clickOn(robot.point(scrollDownButton))
        }
    }
}
