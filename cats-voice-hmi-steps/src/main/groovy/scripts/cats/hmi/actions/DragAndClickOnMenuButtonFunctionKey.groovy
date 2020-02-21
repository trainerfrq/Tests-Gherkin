package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.testfx.service.query.PointQuery
import scripts.agent.testfx.automation.FxScriptTemplate

class DragAndClickOnMenuButtonFunctionKey extends FxScriptTemplate {
    public static final String IPARAM_MENU_BUTTON_ID = "menu_button_id"
    public static final String IPARAM_FUNCTION_KEY_ID = "da_key_id"

    @Override
    void script() {
        String functionKeyId = assertInput(IPARAM_FUNCTION_KEY_ID) as String
        String menuButtonId = assertInput(IPARAM_MENU_BUTTON_ID) as String

        Node functionKeyWidget = robot.lookup("#" + functionKeyId).queryFirst();

        evaluate(ExecutionDetails.create("Function key was found")
                .expected("functionKeyWidget is not null")
                .success(functionKeyWidget != null));

        if (functionKeyId != null) {
            PointQuery pointQuery = robot.point(functionKeyWidget)
            robot.drag(pointQuery)
            robot.dropBy(pointQuery.getPosition().getX() - 100, pointQuery.getPosition().getY())
            Thread.sleep(1000)
            robot.clickOn(robot.point("#" + menuButtonId))
        }
    }
}
