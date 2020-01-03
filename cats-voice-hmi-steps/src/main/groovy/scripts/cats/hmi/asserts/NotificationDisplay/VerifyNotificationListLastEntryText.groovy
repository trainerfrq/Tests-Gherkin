package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.list.listview.CustomListView
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyNotificationListLastEntryText extends FxScriptTemplate {

    public static final String IPARAM_TEXT = "text"
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {

        String text = assertInput(IPARAM_TEXT) as String
        String listName = assertInput(IPARAM_LIST_NAME) as String

        Node notificationPopup = robot.lookup("#notificationPopup").queryFirst()

        evaluate(ExecutionDetails.create("Notification popup was found")
                .expected("Notification popup is visible")
                .success(notificationPopup.isVisible()))

        if (notificationPopup.isVisible()) {
            final CustomListView list = robot.lookup( "#notification"+listName+"List" ).queryFirst()
            int lastEntryIndex = list.getItems().size() -1;

            Label textLabel = robot.lookup("#notification"+listName+"List #notificationEntry_"+lastEntryIndex+" #notificationTextLabel").queryFirst()

                evaluate(ExecutionDetails.create("Notification list "+listName+" text is the expected one")
                        .received(textLabel.getText())
                        .expected(text)
                        .success(textLabel.getText().contains(text)));


        }
    }
}

