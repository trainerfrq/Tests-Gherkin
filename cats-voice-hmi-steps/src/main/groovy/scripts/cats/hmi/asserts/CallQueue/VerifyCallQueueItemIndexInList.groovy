package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueItemIndexInList extends FxScriptTemplate {

    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_CALL_QUEUE_ITEM_INDEX = "call_queue_item_index"
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {

        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String
        Integer callQueueItemIndex= assertInput(IPARAM_CALL_QUEUE_ITEM_INDEX) as Integer;

        Set<Node> callQueueItems = robot.lookup("#"+ callQueueListName+ " .callQueueItem").queryAll()
        String receivedCallQueueItemId = callQueueItems[callQueueItemIndex].id

        evaluate(ExecutionDetails.create("Verify call queue item is in the call queue list at the right position")
                .expected(callQueueItemId)
                .received("Call queue item number "+ callQueueItemIndex + " from " + callQueueListName + " is " + receivedCallQueueItemId)
                .success(receivedCallQueueItemId == callQueueItemId))
    }
}
