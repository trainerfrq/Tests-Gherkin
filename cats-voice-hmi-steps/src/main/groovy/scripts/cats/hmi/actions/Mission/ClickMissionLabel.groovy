package scripts.cats.hmi.actions.Mission

import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

/**
 * @author dindre
 */
class ClickMissionLabel extends FxScriptTemplate {

    public static final String IPARAM_MISSION_DISPLAY_LABEL = "mission_display_label";

    @Override
    protected void script() {
        String label = assertInput(IPARAM_MISSION_DISPLAY_LABEL) as String;

        Label missionLabel = robot.lookup("#status1 #" + label).queryFirst();

        if (missionLabel != null) {
            robot.clickOn(robot.point(missionLabel));
        }
    }
}
