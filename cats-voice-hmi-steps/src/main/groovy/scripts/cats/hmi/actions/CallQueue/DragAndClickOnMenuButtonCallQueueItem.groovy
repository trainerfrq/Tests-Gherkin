package scripts.cats.hmi.actions.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.testfx.service.query.PointQuery
import scripts.agent.testfx.automation.FxScriptTemplate

class DragAndClickOnMenuButtonCallQueueItem extends FxScriptTemplate {
    public static final String IPARAM_MENU_BUTTON_ID = "menu_button_id";
    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id";

    @Override
    void script() {
        String menuButtonId = assertInput(IPARAM_MENU_BUTTON_ID) as String;
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String;

        Node callQueueItem = robot.lookup("#" + callQueueItemId).queryFirst();

        evaluate(ExecutionDetails.create("Found call queue item " + callQueueItemId)
                .expected("Call queue item is not null")
                .success(callQueueItem != null));

        if (callQueueItem != null) {
            PointQuery pointQuery = robot.point(callQueueItem)
            robot.drag(pointQuery)
            robot.dropBy(pointQuery.getPosition().getX() - 100, pointQuery.getPosition().getY())

            while ({
                Thread.sleep(100)
                Node searchedMenuButton = robot.lookup("#" + menuButtonId).tryQueryFirst().get()
                !searchedMenuButton.isVisible()
            }()) continue

            robot.clickOn(robot.point("#" + menuButtonId))
        }
    }
}

