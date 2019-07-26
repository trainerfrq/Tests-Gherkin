package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ListView
import javafx.scene.layout.HBox
import javafx.scene.layout.Pane
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyNotificationListSeverity extends FxScriptTemplate {

    public static final String IPARAM_SEVERITY = "severity"
    public static final String IPARAM_LIST_NAME = "list_name"
    public static final String IPARAM_LIST_ENTRY = "list_entry"

    @Override
    void script() {

        String severity = assertInput(IPARAM_SEVERITY) as String
        String listName = assertInput(IPARAM_LIST_NAME) as String
        String listEntry = assertInput(IPARAM_LIST_ENTRY) as String
        Integer entryNumber = Integer.valueOf(listEntry.substring(listEntry.indexOf("_") + 1)) - 1;

        Node notificationPopup = robot.lookup("#notificationPopup").queryFirst()

        evaluate(ExecutionDetails.create("Notification popup was found")
                .expected("Notification popup is not null")
                .success(notificationPopup != null))

        if (notificationPopup != null) {
            Node notificationEntry = robot.lookup("#notificationEventList #notificationEntry_"+ entryNumber.toString() + " .notificationListItem").queryFirst()
            evaluate(ExecutionDetails.create("Notification list "+listName+" severity is the expected one")
                    .received(Arrays.toString(notificationEntry.getStyleClass().toArray()))
                    .expected(severity)
                    .success(notificationEntry.getStyleClass().contains(severity)));

        }
    }
}

