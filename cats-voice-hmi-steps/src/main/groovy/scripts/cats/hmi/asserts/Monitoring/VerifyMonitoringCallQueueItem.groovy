package scripts.cats.hmi.asserts.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyMonitoringCallQueueItem extends FxScriptTemplate {
    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_MONITORING_TYPE = "monitoring_id"

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        String monitoringType = assertInput(IPARAM_MONITORING_TYPE) as String

        Node callQueueItem = robot.lookup("#" + callQueueItemId).queryFirst()

        if (callQueueItem != null) {
            evaluate(ExecutionDetails.create("Verify call queue item was found")
                    .expected("Call queue item with id " + callQueueItemId + " was found")
                    .success(callQueueItem != null))

            Label monitoringLabel = (Label) callQueueItem.lookup("#typeLabel")

            evaluate(ExecutionDetails.create("Verify monitoring label contains expected text")
                    .expected("Expected text is" +monitoringType)
                    .received("Received text is "+monitoringLabel.getText())
                    .success(monitoringLabel.getText().contains(monitoringType)))
        }
    }
}
