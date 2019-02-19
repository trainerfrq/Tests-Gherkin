package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.testfx.service.query.PointQuery
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyMenuButtonFirstCallQueueItemIsVisible extends FxScriptTemplate {
    public static final String IPARAM_MENU_BUTTON_ID = "menu_button_id";
    public static final String IPARAM_LIST_NAME = "list_name";
    public static final String IPARAM_IS_VISIBLE= "is_visible";

    @Override
    void script() {
        String menuButtonId = assertInput(IPARAM_MENU_BUTTON_ID) as String;
        String listName = assertInput(IPARAM_LIST_NAME) as String;
        Boolean isVisible = assertInput(IPARAM_IS_VISIBLE) as Boolean;

        Node callQueueItem = robot.lookup("#" + listName).queryFirst();

        evaluate(ExecutionDetails.create("Call queue item found in " + listName)
                .expected("Call queue item is not null")
                .success(callQueueItem != null));

        if (callQueueItem != null) {
            PointQuery pointQuery = robot.point(callQueueItem)
            robot.drag(pointQuery)
            robot.dropBy(pointQuery.getPosition().getX() - 100, pointQuery.getPosition().getY())
            Thread.sleep(1000)
            Node menuButton = robot.lookup("#" + menuButtonId).queryFirst();
            if(isVisible) {
                evaluate(ExecutionDetails.create("Menu button " + menuButtonId + " is visible")
                        .expected("Menu button is visible: " + isVisible)
                        .success(menuButton != null));
            }
            else{
                    evaluate(ExecutionDetails.create("Menu button " + menuButtonId + " is not visible")
                            .expected("Menu button is visible: " + isVisible)
                            .success(menuButton == null));
            }
        }
    }
}
