package scripts.cats.hmi.actions.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.google.common.base.Optional
import javafx.scene.Node
import org.testfx.api.FxRobotException
import org.testfx.service.query.NodeQuery
import org.testfx.service.query.PointQuery
import scripts.agent.testfx.automation.FxScriptTemplate

class DragAndClickOnMenuButtonFirstCallQueueItem extends FxScriptTemplate {
    public static final String IPARAM_MENU_BUTTON_ID = "menu_button_id";
    public static final String IPARAM_LIST_NAME = "list_name";

    @Override
    void script() {
        String menuButtonId = assertInput(IPARAM_MENU_BUTTON_ID) as String;
        String listName = assertInput(IPARAM_LIST_NAME) as String;

        Node callQueueItem = robot.lookup("#" + listName).queryFirst();

        evaluate(ExecutionDetails.create("Call queue item found in " + listName)
                .expected("Call queue item is not null")
                .success(callQueueItem != null));

        if (callQueueItem != null) {
            PointQuery pointQuery = robot.point(callQueueItem)
            robot.drag(pointQuery)
            robot.dropBy(pointQuery.getPosition().getX() - 100, pointQuery.getPosition().getY())

            while ({
                Thread.sleep(100)
                NodeQuery searchedMenuButton = robot.lookup("#" + menuButtonId)
                Optional<Node> resultNode = searchedMenuButton.tryQueryFirst();
                Node node = resultNode.get()
                !node.isVisible()
            }()) continue

            robot.clickOn(robot.point("#" + menuButtonId))
        }
    }
}
