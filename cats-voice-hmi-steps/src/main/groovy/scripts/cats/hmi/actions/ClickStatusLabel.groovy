package scripts.cats.hmi.actions

import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

/**
 * @author dindre
 */
class ClickStatusLabel extends FxScriptTemplate {

    public static final String IPARAM_DISPLAY_LABEL = "display_label";

    @Override
    protected void script() {
        String label = assertInput(IPARAM_DISPLAY_LABEL) as String;

        Label expectedLabel = robot.lookup("#status1 #" + label + "Label").queryFirst();

        if (expectedLabel != null) {
            robot.clickOn(robot.point(expectedLabel));
        }
    }
}
