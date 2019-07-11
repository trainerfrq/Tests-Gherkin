package scripts.cats.hmi.actions

import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

/**
 * @author dindre
 */
class ClickStatusLabel extends FxScriptTemplate {

    public static final String IPARAM_DISPLAY_LABEL = "display_label";
    public static final String IPARAM_STATUS_KEY_ID = "status_key_id";

    @Override
    protected void script() {
        String label = assertInput(IPARAM_DISPLAY_LABEL) as String;
        String statusKeyId = assertInput(IPARAM_STATUS_KEY_ID) as String;

        Label expectedLabel = robot.lookup("#"+statusKeyId+" #" + label + "Label").queryFirst();

        if (expectedLabel != null) {
            robot.clickOn(robot.point(expectedLabel));
        }
    }
}
