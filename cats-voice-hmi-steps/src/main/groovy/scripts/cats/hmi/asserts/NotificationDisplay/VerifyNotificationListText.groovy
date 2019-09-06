package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyNotificationListText extends FxScriptTemplate {

    public static final String IPARAM_TEXT = "text"
    public static final String IPARAM_LIST_NAME = "list_name"
    public static final String IPARAM_LIST_ENTRY = "list_entry"

    @Override
    void script() {

        String text = assertInput(IPARAM_TEXT) as String
        String listName = assertInput(IPARAM_LIST_NAME) as String
        String listEntry = assertInput(IPARAM_LIST_ENTRY) as String
        Integer entryNumber = Integer.valueOf(listEntry.substring(listEntry.indexOf("_") + 1)) - 1;

        Node notificationPopup = robot.lookup("#notificationPopup").queryFirst()

        evaluate(ExecutionDetails.create("Notification popup was found")
                .expected("Notification popup is visible")
                .success(notificationPopup.isVisible()))

        if (notificationPopup.isVisible()) {
            Label textLabel = robot.lookup("#notification"+listName+"List #notificationEntry_"+ entryNumber.toString() +" #notificationTextLabel").queryFirst()

            evaluate(ExecutionDetails.create("Notification list entry was found")
                    .expected("Notification list entry is not null")
                    .success(textLabel != null))

            evaluate(ExecutionDetails.create("Notification list "+listName+" text is the expected one")
                    .received(textLabel.toString())
                    .expected(text)
                    .success(textLabel.toString().contains(text)));

        }
    }
}

