package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.list.listview.CustomListView
import javafx.scene.Node
import javafx.scene.control.Label
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
            final CustomListView list = robot.lookup( "#notification"+listName+"List" ).queryFirst()
            List<String> allEntriesTextLabels = new ArrayList<>()
            int receivedListSize = list.getItems().size();
            int roundValue = Math.ceil(receivedListSize/6)

            for(int index=0; index<roundValue; index++){
                for(int i=0; i<6; i++){

                    Label textLabel = robot.lookup("#notification"+listName+"List #notificationEntry_"+i+" #notificationTextLabel").queryFirst()
                    if(textLabel!=null){
                        allEntriesTextLabels.add(textLabel.getText())
                    }
                    final Node scrollDownButton = robot.lookup("#notificationPopup #scrollDown"+listName+"List").queryFirst()
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
