package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueItemPriority extends FxScriptTemplate {
    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_CALL_QUEUE_ITEM_PRIORITY = "call_queue_item_priority"

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String;
        String callQueueItemPriority = assertInput(IPARAM_CALL_QUEUE_ITEM_PRIORITY) as String;

        Node callQueueItem = robot.lookup("#" + callQueueItemId).queryFirst();

        evaluate(ExecutionDetails.create("Verify call queue item was found")
                .expected("Call queue item with id " + callQueueItemId + " was found")
                .success(callQueueItem != null));

        if (callQueueItemPriority.toUpperCase().equals("EMERGENCY")) {
            evaluate(ExecutionDetails.create("Verify call queue item has priority: " + callQueueItemPriority)
                    .expected("Expected priority: " + callQueueItemPriority)
                    .received("Received priority: " + callQueueItem.getStyleClass())
                    .success(callQueueItem.getStyleClass().contains("priority")));
        } else {
            evaluate(ExecutionDetails.create("Verify call queue item has priority: " + callQueueItemPriority)
                    .expected("Expected priority: " + callQueueItemPriority)
                    .received("Received priority: " + callQueueItem.getStyleClass())
                    .success(!(callQueueItem.getStyleClass().contains("priority"))));
        }
    }
}
