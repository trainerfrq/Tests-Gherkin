package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ListView
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyNotificationListSeverity extends FxScriptTemplate {

    public static final String IPARAM_SEVERITY = "severity"
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {

        String severity = assertInput(IPARAM_SEVERITY) as String
        String listName = assertInput(IPARAM_LIST_NAME) as String

        Node notificationPopup = robot.lookup("#notificationPopup").queryFirst()

        evaluate(ExecutionDetails.create("Notification popup was found")
                .expected("Notification popup is not null")
                .success(notificationPopup != null))

        if (notificationPopup != null) {
            final ListView list = robot.lookup( "#notification"+listName+"List" ).queryFirst()
            int receivedListSize = list.getItems().size();

            for(int i = 0;i<receivedListSize;i++){

                Node notificationEntry = robot.lookup("#notification"+listName+"List #notificationEntry_"+i).queryFirst()

                evaluate(ExecutionDetails.create("Notification list "+listName+" severity is the expected one")
                        .expected(severity)
                        .success(notificationEntry.getStyleClass().contains(severity)));

            }
        }
    }
}

