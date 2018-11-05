package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueItemNotInList extends FxScriptTemplate {

    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String

        String callQueueItemQueryString = "#".concat(callQueueListName)
                .concat(" #")
                .concat(callQueueItemId)

        Node callQueueItem = robot.lookup(callQueueItemQueryString).queryFirst()

        evaluate(ExecutionDetails.create("Assert call queue item " + callQueueItemId + " is not in the " + callQueueListName + " list")
                .expected("Call queue item with id " + callQueueItemId + " wasn't found in " + callQueueListName )
                .success(callQueueItem == null))
    }
}
