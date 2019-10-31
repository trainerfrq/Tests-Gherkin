package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyNotificationListFirstPageEntriesText extends FxScriptTemplate {

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
            List<String> allEntriesTextLabels = new ArrayList<String>()
            for(int i=0; i<6; i++){
                Label textLabel = robot.lookup("#notification"+listName+"List #notificationEntry_"+i+" #notificationTextLabel").queryFirst()
                if(textLabel!=null){
                    allEntriesTextLabels.add(textLabel.getText())
                }
            }
                evaluate(ExecutionDetails.create("Notification list "+listName+" contains text")
                        .received(allEntriesTextLabels.toString())
                        .expected(text)
                        .success(allEntriesTextLabels.contains(text)));
        }
    }
}

