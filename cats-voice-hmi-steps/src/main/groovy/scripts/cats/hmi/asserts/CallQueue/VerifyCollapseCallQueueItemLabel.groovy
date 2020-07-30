package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.voice.hmi.component.layout.list.item.callQueue.CallQueueListItem
import com.frequentis.voice.hmi.component.layout.list.scrollpane.CallQueueListView
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

        List<CallQueueListItem> activeListItems = activeCallQueueList.getCollapsedCallQueueListItemsReadOnly();

        Optional<CallQueueListItem> optionalSearchedItem = activeListItems.stream().filter { callQueueListItem -> (callQueueListItem.getId() == callQueueItemId) }.findFirst()

        if (optionalSearchedItem.isPresent()) {

            Label callQueueItemLabel = (Label) optionalSearchedItem.get().lookup("#nameLabel")

            evaluate(ExecutionDetails.create("Assert call queue item name label")
                    .success(verifyNodeHasProperty(callQueueItemLabel, callQueueItemDisplayName, 2300)));

        } else {
            evaluate(ExecutionDetails.create("Call queue item " + callQueueItemId + " was not found")
                    .success(false))
        }
    }

    private boolean verifyNodeHasProperty(Label node, String property, long nWait) {

        WaitCondition condition = new WaitCondition("Wait until node has [" + property + "] value") {
            @Override
            boolean test() {
                String receivedProperty = node.textProperty().getValue();
                DSLSupport.evaluate(ExecutionDetails.create("Verifying has property")
                        .expected("Expected property: " + property)
                        .received("Found property: " + receivedProperty)
                        .success())
                return receivedProperty.contains(property);

            }
        }
        return WaitTimer.pause(condition, nWait, 250);
    }
}


