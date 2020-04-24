package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate
import scripts.utils.StyleClass

class VerifyCallQueueItemStateIfPresent extends FxScriptTemplate {
    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_CALL_QUEUE_ITEM_CLASS_NAME = "call_queue_item_class_name"

    public static final String OPARAM_CALL_QUEUE_ITEM_WAS_FOUND = "call_queue_item_class_name"

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        String callQueueItemState = assertInput(IPARAM_CALL_QUEUE_ITEM_CLASS_NAME) as String

        Node callQueueItem = robot.lookup("#" + callQueueItemId).queryFirst()

        if (callQueueItem != null) {
            evaluate(ExecutionDetails.create("Verify call queue item was found")
                    .expected("Call queue item with id " + callQueueItemId + " was found")
                    .success(callQueueItem != null))

            evaluate(ExecutionDetails.create("Verify call queue item has styleClass: " + callQueueItemState)
                    .success(StyleClass.verifyNodeHasClass(callQueueItem, callQueueItemState, 3000)))
        } else {
            evaluate(ExecutionDetails.create("Verify call queue item was found")
                    .expected("Call queue item with id " + callQueueItemId + " was NOT found")
                    .success())
        }
        
        setOutput(OPARAM_CALL_QUEUE_ITEM_WAS_FOUND, callQueueItem != null)
    }
}
