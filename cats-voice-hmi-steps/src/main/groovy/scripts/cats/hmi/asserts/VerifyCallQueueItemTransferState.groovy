package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.collections.ObservableSet
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueItemTransferState extends FxScriptTemplate {

    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_KEY_STATE = "key_state"

    @Override
    void script() {

        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        String callQueueState = assertInput(IPARAM_KEY_STATE) as String

        final PseudoClass pseudoClassState = PseudoClass.getPseudoClass(callQueueState)

        Node callQueueItem = robot.lookup("#" + callQueueItemId).queryFirst();

        evaluate(ExecutionDetails.create("Verify call queue item was found")
                .expected("Call queue item with id " + callQueueItemId + " was found")
                .success(callQueueItem != null))

        evaluate(ExecutionDetails.create("Verify PseudoClassStates contains: " + callQueueState)
                .success(verifyNodeHasPseudoClass(callQueueItem, pseudoClassState, 10000)))
    }

    protected static boolean verifyNodeHasPseudoClass(Node node, PseudoClass pseudoClassState, long nWait) {

        WaitCondition condition = new WaitCondition("Wait until node has [" + pseudoClassState + "] class") {
            @Override
            boolean test() {
                ObservableSet<PseudoClass> pseudoClass = node.pseudoClassStates
                DSLSupport.evaluate(ExecutionDetails.create("Verifying has class")
                        .expected("Expected class: " + pseudoClassState)
                        .received("Found classes: " + pseudoClass)
                        .success())
                return pseudoClass.contains(pseudoClassState)
            }
        }
        return WaitTimer.pause(condition, nWait, 400)
    }
}
