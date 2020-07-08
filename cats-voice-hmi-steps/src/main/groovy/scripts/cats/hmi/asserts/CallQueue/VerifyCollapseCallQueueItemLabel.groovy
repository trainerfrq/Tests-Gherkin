package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.voice.hmi.component.layout.list.item.callQueue.CallQueueListItem
import com.frequentis.voice.hmi.component.layout.list.scrollpane.CallQueueListView
import javafx.collections.ObservableList
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyCollapseCallQueueItemLabel extends FxScriptTemplate {
    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id";
    public static final String IPARAM_DISPLAY_NAME = "display_name";
    public static final String IPARAM_LIST_NAME = "list_name";

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String
        String callQueueItemDisplayName = assertInput(IPARAM_DISPLAY_NAME) as String

        CallQueueListView activeCallQueueList = robot.lookup("#" + callQueueListName).queryFirst();

        ObservableList<CallQueueListItem> activeListItems = activeCallQueueList.getCollapsedCallQueueListItemsReadOnly();

        CallQueueListItem searchedItem = activeListItems.stream().filter { callQueueListItem -> (callQueueListItem.getId() == callQueueItemId) }.findFirst().get()

        Label callQueueItemLabel = (Label) searchedItem.lookup("#nameLabel")


        int attempt = 1
        int numberOfVerificationRetries = 9 //it will verify the call queue label for maximum 2.3 seconds
        while (callQueueItemLabel.getText() != callQueueItemDisplayName) {
            WaitTimer.pause(250);
            attempt++
            if ((callQueueItemLabel.getText() == callQueueItemDisplayName) || attempt > numberOfVerificationRetries)
                break
        }

        evaluate(ExecutionDetails.create("Assert call queue item name label")
                .expected("Call queue item with id " + callQueueItemId + " and display name " + callQueueItemDisplayName + " was found")
                .received("The received label is: " + callQueueItemLabel.getText())
                .success(callQueueItemLabel.getText() == callQueueItemDisplayName))
    }
}


