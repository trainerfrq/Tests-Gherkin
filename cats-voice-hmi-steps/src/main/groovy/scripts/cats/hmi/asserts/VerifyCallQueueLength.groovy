package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueLength extends FxScriptTemplate {
    public static final String IPARAM_QUEUE_EXPECTED_LENGTH = "expected_queue_length";

    @Override
    void script() {
        Integer callQueueLength = assertInput(IPARAM_QUEUE_EXPECTED_LENGTH) as Integer;

        Set<Node> callQueueItems = robot.lookup(".callQueueItem").queryAll();

        evaluate(ExecutionDetails.create("Verify call queue length is matching")
                .expected("Call queue with a number of " + callQueueLength + " items")
                .received("Call queue with a number of " + callQueueItems.size() + " items")
                .success(callQueueLength == callQueueItems.size()));
    }
}
