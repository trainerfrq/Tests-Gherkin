package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate
import scripts.utils.StyleClass

class VerifyCallQueueItemStyleClass extends FxScriptTemplate {
    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_CALL_QUEUE_ITEM_CLASS_NAME = "call_queue_item_class_name"

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String;
        String callQueueItemState = assertInput(IPARAM_CALL_QUEUE_ITEM_CLASS_NAME) as String;

        Node callQueueItem = robot.lookup("#" + callQueueItemId).queryFirst();

        int i = 1
        while (callQueueItem == null){
            WaitTimer.pause(250);
            callQueueItem = robot.lookup("#" + callQueueItemId).queryFirst();
            i++
            if(callQueueItem != null || i > 9)
                break
        }

        evaluate(ExecutionDetails.create("Verify call queue item was found")
                .expected("Call queue item with id " + callQueueItemId + " was found")
                .success(callQueueItem.isVisible()));

        evaluate(ExecutionDetails.create("Verify call queue item has styleClass: " + callQueueItemState)
                .success(StyleClass.verifyNodeHasClass(callQueueItem, callQueueItemState, 3000)));
    }
}
