package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.testfx.service.query.PointQuery
import scripts.agent.testfx.automation.FxScriptTemplate

class DragAndClickOnMenuButtonActiveList extends FxScriptTemplate {
    public static final String IPARAM_MENU_BUTTON_ID = "menu_button_id";

    @Override
    void script() {
        String menuButtonId = assertInput(IPARAM_MENU_BUTTON_ID) as String;

        Node activeCallQueueItem = robot.lookup("#activeList").queryFirst();

        evaluate(ExecutionDetails.create("Active call queue item found")
                .expected("Active call queue item is not null")
                .success(activeCallQueueItem != null));

        if (activeCallQueueItem != null) {
            PointQuery pointQuery = robot.point(activeCallQueueItem)
            robot.drag(pointQuery)
            robot.dropBy(pointQuery.getPosition().getX() - 100, pointQuery.getPosition().getY())
            Thread.sleep(1000)
            robot.clickOn(robot.point(menuButtonId))
        }
    }
}
