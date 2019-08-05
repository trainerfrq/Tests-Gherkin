package scripts.cats.hmi.actions.AudioSettings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class CleanUpMuteSideToneButton extends FxScriptTemplate {

    public static final String IPARAM_MUTE_BUTTON_NAME = "button_name"

    @Override
    void script() {

        String buttonName = assertInput(IPARAM_MUTE_BUTTON_NAME) as String

        Node muteSidetoneButton = robot.lookup("#" + buttonName + "MuteSidetoneButton").queryFirst();

        if (muteSidetoneButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("muted"))) {
            robot.clickOn(robot.point(muteSidetoneButton))
        } else {
            evaluate(ExecutionDetails.create("Button is in expected state")
                    .received("Received state is: " + muteSidetoneButton.getPseudoClassStates())
                    .success(true))
        }
    }
}
