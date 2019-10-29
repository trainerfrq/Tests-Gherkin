package scripts.cats.hmi.asserts.Settings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyClosePanelButtonState extends FxScriptTemplate {

    public static final String IPARAM_BUTTON_NUMBER= "button_number"
    public static final String IPARAM_STATE = "state_mode"

    @Override
    void script() {

        Integer buttonNumber = assertInput(IPARAM_BUTTON_NUMBER) as Integer
        String state = assertInput(IPARAM_STATE) as String

        Node button = robot.lookup("#closePanelButton_" + buttonNumber).queryFirst()

        evaluate(ExecutionDetails.create("Button was found")
                .expected("Button is not null")
                .success(button.isVisible()))

        switch(state){
            case "selected":
                evaluate(ExecutionDetails.create("Verify that close panel button state is: " + state)
                        .expected("Close panel button state is: " + state)
                        .success(button.getPseudoClassStates().contains(PseudoClass.getPseudoClass("selected"))))
                break
            case "next":
                evaluate(ExecutionDetails.create("Verify that close panel button state is: " + state)
                        .expected("Close panel button state is: " + state)
                        .success(!button.getPseudoClassStates().contains(PseudoClass.getPseudoClass("next"))))
                break
            default:
                break
        }
    }

}
