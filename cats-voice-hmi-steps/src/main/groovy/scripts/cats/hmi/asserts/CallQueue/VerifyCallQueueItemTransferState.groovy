package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate
import scripts.utils.PseudoClassStates

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
                .success(PseudoClassStates.verifyNodeHasPseudoClass(callQueueItem, pseudoClassState, 3000)))
    }
}
