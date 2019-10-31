package scripts.cats.hmi.actions.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ListView
import scripts.agent.testfx.automation.FxScriptTemplate

class CountStateListItems extends FxScriptTemplate {

    public static final String OPARAM_ITEMS_NUMBER = "items_number"

    @Override
    void script() {

        Node notificationPopup = robot.lookup("#notificationPopup").queryFirst()

        evaluate(ExecutionDetails.create("Notification popup was found")
                .expected("Notification popup is visible")
                .success(notificationPopup.isVisible()))

        if (notificationPopup.isVisible()) {
            final ListView list = robot.lookup("#notificationStateList").queryFirst()
            int receivedListSize = list.getItems().size();
            evaluate(ExecutionDetails.create("State list number of items")
                    .received(receivedListSize.toString())
                    .success(true));
            setOutput(OPARAM_ITEMS_NUMBER, receivedListSize.toString())
        }
    }
}

