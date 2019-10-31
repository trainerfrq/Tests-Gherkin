package scripts.cats.hmi.actions.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.ListView
import scripts.agent.testfx.automation.FxScriptTemplate

class CountStateListItemsOnFirstTwoPages extends FxScriptTemplate {

    public static final String OPARAM_ITEMS_NUMBER = "items_number"

    @Override
    void script() {

        Node notificationPopup = robot.lookup("#notificationPopup").queryFirst()

        evaluate(ExecutionDetails.create("Notification popup was found")
                .expected("Notification popup is visible")
                .success(notificationPopup.isVisible()))

        if (notificationPopup.isVisible()) {
            final ListView list = robot.lookup( "#notificationStateList" ).queryFirst()
            int receivedListSize = list.getItems().size();

            List<String> allEntriesTextLabels = new ArrayList<String>()
            for(int i=0; i<receivedListSize; i++){
                Label textLabel = robot.lookup("#notificationStateList #notificationEntry_"+i+" #notificationTextLabel").queryFirst()
                if(textLabel!=null){
                    allEntriesTextLabels.add(textLabel.getText())
                }
                if(i==5&&receivedListSize>6){
                    final Node scrollDownButton = robot.lookup("#notificationStateList #scrollDownStateList").queryFirst()
                    robot.clickOn(robot.point(scrollDownButton))
                }
             }
        }
        evaluate(ExecutionDetails.create("State list number of items")
                    .received(allEntriesTextLabels.size().toString())
                    .success(true));

        setOutput(OPARAM_ITEMS_NUMBER, allEntriesTextLabels.size().toString())
    }
}

