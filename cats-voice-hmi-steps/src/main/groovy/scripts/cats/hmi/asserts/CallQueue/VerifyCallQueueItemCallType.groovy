package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueItemCallType extends FxScriptTemplate {

    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_DISPLAY_CALL_TYPE = "display_call_type"
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String
        String callQueueItemDisplayCallType = assertInput(IPARAM_DISPLAY_CALL_TYPE) as String

        String callQueueItemQueryString = "#".concat(callQueueListName)
                .concat(" #")
                .concat(callQueueItemId)
                .concat(" #typeLabel")

        Label receivedCallQueueItemCallType = robot.lookup(callQueueItemQueryString).queryFirst()

        evaluate(ExecutionDetails.create("Assert call queue item callType label")
                .expected("Call queue item has displayed call type: " + callQueueItemDisplayCallType )
                .received("Received call type: " + receivedCallQueueItemCallType.getText())
                .success(receivedCallQueueItemCallType.getText() == callQueueItemDisplayCallType))
    }
}
