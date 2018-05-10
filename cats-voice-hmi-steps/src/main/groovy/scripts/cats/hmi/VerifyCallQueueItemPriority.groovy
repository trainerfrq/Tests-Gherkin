package scripts.cats.hmi

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueItemPriority extends FxScriptTemplate {
    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id";
    public static final String PRIORITY_STYLE_CLASS_NAME = "priority";

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String;

        Node callQueueItem = robot.lookup("#" + callQueueItemId).queryFirst();

        evaluate(ExecutionDetails.create("Verify call queue item was found")
                .expected("Call queue item with id " + callQueueItemId + " was found")
                .success(callQueueItem != null));

        evaluate(ExecutionDetails.create("Verify call queue item has styleClass: priority")
                .success(verifyNodeHasClass(callQueueItem, 10000)));
    }

    protected static boolean verifyNodeHasClass(Node node, long nWait) {
        String styleClass = node.styleClass.join(" ");
        WaitCondition condition = new WaitCondition("Wait until node has [" + PRIORITY_STYLE_CLASS_NAME + "] class") {
            @Override
            boolean test() {
                DSLSupport.evaluate(ExecutionDetails.create("Verifying has class")
                        .expected("Expected class: " + PRIORITY_STYLE_CLASS_NAME)
                        .received("Found classes: " + styleClass)
                        .success())
                return styleClass.contains(PRIORITY_STYLE_CLASS_NAME);

            }
        }
        return WaitTimer.pause(condition, nWait, 400);
    }
}
