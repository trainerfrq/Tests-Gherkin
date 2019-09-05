package scripts.cats.hmi.asserts.AudioSettings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyMuteButtonState extends FxScriptTemplate {

    public static final String IPARAM_MUTE_BUTTON_NAME= "button_name"
    public static final String IPARAM_STATE = "state_mode"

    @Override
    void script() {

        String buttonName = assertInput(IPARAM_MUTE_BUTTON_NAME) as String
        String state = assertInput(IPARAM_STATE) as String

        Node muteButton = robot.lookup("#mute"+buttonName+"Button").queryFirst()

        evaluate(ExecutionDetails.create("Mute button was found")
                .expected("Mute button is visible")
                .success(muteButton.isVisible()))

        switch(state){
            case "muted":
                evaluate(ExecutionDetails.create("Verify that mute button state is: " + state)
                        .expected("Mute button state is: " + state)
                        .success(muteButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("muted"))))
                break
            case "unmuted":
                evaluate(ExecutionDetails.create("Verify that mute button state is: " + state)
                        .expected("Mute button state is: " + state)
                        .success(!muteButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("muted"))))
                break
            default:
                break
        }


    }
}
