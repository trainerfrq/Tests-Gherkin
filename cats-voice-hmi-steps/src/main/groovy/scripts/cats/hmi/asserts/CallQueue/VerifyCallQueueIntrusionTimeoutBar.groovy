package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueIntrusionTimeoutBar extends FxScriptTemplate {
    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_IS_VISIBLE = "is_visible"

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        Boolean isVisible = assertInput(IPARAM_IS_VISIBLE) as Boolean

        Node callQueueItem = robot.lookup("#" + callQueueItemId + " #callIntrusion").queryFirst()

        if (callQueueItem != null) {
            if (isVisible) {
                evaluate(ExecutionDetails.create("Verify call queue item " + callQueueItemId + " Timeout bar")
                        .expected("Timeout bar is visible: " + isVisible)
                        .success(callQueueItem.isVisible()))
            } else {
                evaluate(ExecutionDetails.create("Verify call queue item " + callQueueItemId + " Timeout bar")
                        .expected("Timeout bar is visible: " + isVisible)
                        .success(!(callQueueItem.isVisible())))
            }

        } else{
            evaluate(ExecutionDetails.create("Call queue item " + callQueueItemId + " Timeout bar wasn't found")
                    .success(false))
        }

    }
}
