package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.testfx.service.query.PointQuery
import scripts.agent.testfx.automation.FxScriptTemplate

class DragAndClickOnMenuButtonDAKey extends FxScriptTemplate {
    public static final String IPARAM_MENU_BUTTON_ID = "menu_button_id"
    public static final String IPARAM_DA_KEY_ID = "da_key_id"

    @Override
    void script() {
        String daKeyId = assertInput(IPARAM_DA_KEY_ID) as String
        String menuButtonId = assertInput(IPARAM_MENU_BUTTON_ID) as String

        Node daWidget = robot.lookup("#" + daKeyId).queryFirst()

        evaluate(ExecutionDetails.create("DA key was found")
                .expected("daWidget is not null")
                .success(daWidget != null));

        if (daWidget != null) {
            PointQuery pointQuery = robot.point(daWidget)
            robot.drag(pointQuery)
            robot.dropBy(pointQuery.getPosition().getX() - 100, pointQuery.getPosition().getY())
            Thread.sleep(1000)
            robot.clickOn(robot.point("#" + menuButtonId))
        }
    }
}
