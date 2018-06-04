package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
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
            Thread.sleep(1000)
            robot.clickOn(robot.point("#" + menuButtonId))
        }
    }
}
