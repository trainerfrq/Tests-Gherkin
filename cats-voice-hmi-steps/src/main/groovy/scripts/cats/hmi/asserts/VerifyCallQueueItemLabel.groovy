package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueItemLabel extends FxScriptTemplate {
    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id";
    public static final String IPARAM_DISPLAY_NAME = "display_name";
    public static final String IPARAM_LIST_NAME = "list_name";

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String
        String callQueueItemDisplayName = assertInput(IPARAM_DISPLAY_NAME) as String

        String callQueueItemQueryString = "#".concat(callQueueListName)
                .concat(" #")
                .concat(callQueueItemId)
                .concat(" #nameLabel")

        Label callQueueItemLabel = robot.lookup(callQueueItemQueryString).queryFirst()

        evaluate(ExecutionDetails.create("Assert call queue item name label")
                .expected("Call queue item with id " + callQueueItemId + " and display name " + callQueueItemDisplayName + " was found")
                .received("The received label is: " + callQueueItemLabel.getText())
                .success(callQueueItemLabel.getText() == callQueueItemDisplayName))
    }
}
