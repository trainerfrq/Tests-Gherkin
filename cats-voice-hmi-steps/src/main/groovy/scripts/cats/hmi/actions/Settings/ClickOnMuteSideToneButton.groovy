package scripts.cats.hmi.actions.Settings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

/**
 * @author dindre
 */
class ClickOnMuteSideToneButton extends FxScriptTemplate {

    public static final String IPARAM_MUTE_SIDETONE_BUTTON_NAME = "button_name";

    @Override
    protected void script() {
        String buttonName = assertInput(IPARAM_MUTE_SIDETONE_BUTTON_NAME) as String;

        Node muteSidetoneButton = robot.lookup("#" + buttonName + "MuteSidetoneButton").queryFirst();

        evaluate(ExecutionDetails.create("Mute sidetone button was found")
                .expected("Mute sidetone button is not null")
                .success(muteSidetoneButton != null)
        );

        robot.clickOn(robot.point(muteSidetoneButton));
    }
}
