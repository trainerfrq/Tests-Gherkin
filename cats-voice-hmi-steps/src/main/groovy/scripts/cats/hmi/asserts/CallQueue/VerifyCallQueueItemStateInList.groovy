package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate
import scripts.utils.VerifyStyleClass

class VerifyCallQueueItemStateInList extends FxScriptTemplate{
    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_CALL_QUEUE_ITEM_CLASS_NAME = "call_queue_item_class_name"
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        String callQueueItemState = assertInput(IPARAM_CALL_QUEUE_ITEM_CLASS_NAME) as String
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String

        String callQueueItemQueryString = "#$callQueueListName #$callQueueItemId"

        Node callQueueItem = robot.lookup(callQueueItemQueryString).queryFirst()

        int attempts = 10
        while (callQueueItem == null){
            WaitTimer.pause(250);
            callQueueItem = robot.lookup(callQueueItemQueryString).queryFirst()
            attempts--
            if(callQueueItem != null || attempts == 0)
                break
        }

        evaluate(ExecutionDetails.create("Verify call queue item was found in " + callQueueListName + " list")
                .expected("Call queue item with id " + callQueueItemId + " was found")
                .success(callQueueItem != null))

        evaluate(ExecutionDetails.create("Verify call queue item has styleClass: " + callQueueItemState)
                .success(VerifyStyleClass.verifyNodeHasClass(callQueueItem, callQueueItemState, 3000)));
    }
}
