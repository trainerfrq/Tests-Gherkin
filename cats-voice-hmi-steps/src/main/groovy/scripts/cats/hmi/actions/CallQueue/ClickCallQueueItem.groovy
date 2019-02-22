package scripts.cats.hmi.actions.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickCallQueueItem extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(ClickCallQueueItem.class);

    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id";

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String;

        Node callQueueItem = robot.lookup("#" + callQueueItemId).queryFirst();

        evaluate(ExecutionDetails.create("Call queue item was found")
                .expected("Call queue item was is not null")
                .success(callQueueItem != null));

        if (callQueueItem != null) {
            robot.clickOn(robot.point(callQueueItem));
            LOGGER.debug("Click on Call queue item key: [{}]", callQueueItemId);
        }
    }
}
