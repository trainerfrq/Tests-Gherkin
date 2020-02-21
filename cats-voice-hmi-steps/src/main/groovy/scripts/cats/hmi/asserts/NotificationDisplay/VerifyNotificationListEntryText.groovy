package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyNotificationListEntryText extends FxScriptTemplate {

    public static final String IPARAM_TEXT = "text"
    public static final String IPARAM_LIST_NAME = "list_name"
    public static final String IPARAM_ENTRY_POSITION = "entry_position"

    @Override
    void script() {

        String text = assertInput(IPARAM_TEXT) as String
        String listName = assertInput(IPARAM_LIST_NAME) as String
        Integer entryPosition = assertInput(IPARAM_ENTRY_POSITION) as Integer

        Node notificationPopup = robot.lookup("#notificationPopup").queryFirst()

        evaluate(ExecutionDetails.create("Notification popup was found")
                .expected("Notification popup is visible")
                .success(notificationPopup.isVisible()))

        if (notificationPopup.isVisible()) {
             Label textLabel = robot.lookup("#notification"+listName+"List #notificationEntry_"+entryPosition+" #notificationTextLabel").queryFirst()

                evaluate(ExecutionDetails.create("Notification list "+listName+" text is the expected one")
                        .received(textLabel.toString())
                        .expected(text)
                        .success(textLabel.toString().contains(text)));


        }
    }
}

