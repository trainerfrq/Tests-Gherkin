package scripts.cats.hmi.actions.CallQueue

import javafx.scene.Node
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnCallQueueItemList extends FxScriptTemplate {

    private static final Logger LOGGER = LoggerFactory.getLogger(ClickCallQueueItem.class);
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {

        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String

        Node listItem = robot.lookup("#" + callQueueListName + " .callQueueItem").queryFirst()

        if (listItem != null) {
            robot.clickOn(robot.point(listItem));
            LOGGER.debug("Click on Call queue list item: [{}]", callQueueListName);
        }
    }
}
