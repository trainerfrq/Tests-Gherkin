package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueLength extends FxScriptTemplate {
    public static final String IPARAM_QUEUE_EXPECTED_LENGTH = "expected_queue_length";

    @Override
    void script() {
        Integer callQueueLength = assertInput(IPARAM_QUEUE_EXPECTED_LENGTH) as Integer;

        Set<Node> activeCallQueueItems = robot.lookup("#activeList .callQueueItem").queryAll();
        Set<Node> holdCallQueueItems = robot.lookup("#holdList .callQueueItem").queryAll();
        Set<Node> waitingCallQueueItems = robot.lookup("#waitingList .callQueueItem").queryAll();
        Set<Node> monitoringCallQueueItems = robot.lookup("#monitoringList .callQueueItem").queryAll();

        int callQueueItems = activeCallQueueItems.size()+holdCallQueueItems.size()+waitingCallQueueItems.size()+monitoringCallQueueItems.size()

        evaluate(ExecutionDetails.create("Verify call queue length is matching")
                .expected("Call queue with a number of " + callQueueLength + " items")
                .received("Call queue with a number of " + callQueueItems + " items")
                .success(callQueueLength == callQueueItems));
    }
}
