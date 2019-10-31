package scripts.cats.hmi.actions.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate


class CountNotificationStateListItems extends FxScriptTemplate {

    public static final String OPARAM_ITEMS_NUMBER = "items_number"

    @Override
    void script() {

        Node notificationPopup = robot.lookup("#notificationPopup").queryFirst()

        evaluate(ExecutionDetails.create("Notification popup was found")
                .expected("Notification popup is visible")
                .success(notificationPopup.isVisible()))

        if (notificationPopup.isVisible()) {
            List<String> allEntriesTextLabels = new ArrayList<String>()
            for(int i=0; i<6; i++){
                Label textLabel = robot.lookup("#notificationStateList #notificationEntry_"+i+" #notificationTextLabel").queryFirst()
                if(textLabel!=null){
                    allEntriesTextLabels.add(textLabel.getText())
                }
            }
            evaluate(ExecutionDetails.create("State list number of items")
                    .received(allEntriesTextLabels.size().toString())
                    .success(true));

            setOutput(OPARAM_ITEMS_NUMBER, allEntriesTextLabels.size().toString())
        }
    }
}
