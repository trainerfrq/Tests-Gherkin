package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.list.listview.CustomListView
import javafx.scene.Node
import javafx.scene.control.Label
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
                .expected("Notification popup is visible")
                .success(notificationPopup.isVisible()))

        if (notificationPopup.isVisible()) {
            final Pane notificationEntry = robot.lookup("#notification"+listName+"List").queryFirst()

            evaluate(ExecutionDetails.create("Verify notification Event List exists")
                    .expected("List of Events exists")
                    .success(notificationEntry != null));

            ObservableList events = notificationEntry.getChildren()
            List<Label> eventsList = new ArrayList<>(events)

            evaluate(ExecutionDetails.create("Notification list "+listName+" severity is the expected one")
                    .expected("Expected severity: " + severity)
                    .received("Received severity: " + eventsList.get(entryNumber).toString())
                    .success(eventsList.get(entryNumber).toString().contains(severity)));

        }
    }
}
