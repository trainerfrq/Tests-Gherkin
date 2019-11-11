package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.ListView
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyNotificationListAllEntriesText extends FxScriptTemplate {

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
            final ListView list = robot.lookup( "#notification"+listName+"List" ).queryFirst()
            final Node scrollDownButton = robot.lookup("#notification"+listName+"List #scrollDown"+listName+"List").queryFirst()
            int receivedListSize = list.getItems().size();
            List<String> allEntriesTextLabels = new ArrayList<String>()

            for(int index=0; index<receivedListSize/6; index++){
                for(int i=0; i<6; i++){
                    Label textLabel = robot.lookup("#notification"+listName+"List #notificationEntry_"+i+" #notificationTextLabel").queryFirst()
                    if(textLabel!=null){
                        allEntriesTextLabels.add(textLabel.getText())
                }
                    robot.clickOn(robot.point(scrollDownButton))
            }
         }
         evaluate(ExecutionDetails.create("Notification list "+listName+" contains text")
                .received(allEntriesTextLabels.toString())
                .expected(text)
                .success(allEntriesTextLabels.contains(text)));
        }
    }
}

