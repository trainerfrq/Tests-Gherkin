package scripts.cats.hmi.actions.Settings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class CleanUpMuteButton extends FxScriptTemplate {

    public static final String IPARAM_MUTE_BUTTON_NAME = "button_name"

    @Override
    void script() {

        String buttonName = assertInput(IPARAM_MUTE_BUTTON_NAME) as String

        Node muteButton = robot.lookup("#mute" + buttonName + "Button").queryFirst()

        if (muteButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("muted"))) {
            robot.clickOn(robot.point(muteButton))
        } else {
            evaluate(ExecutionDetails.create("Button is in expected state")
                    .received("Received state is: " + muteButton.getPseudoClassStates())
                    .success(true))
        }
    }
}
