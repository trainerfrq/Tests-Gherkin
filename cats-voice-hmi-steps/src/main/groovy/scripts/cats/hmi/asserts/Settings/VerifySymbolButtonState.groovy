package scripts.cats.hmi.asserts.Settings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifySymbolButtonState extends FxScriptTemplate{
    public static String IPARAM_BUTTON_NAME = "button_name";
    public static String IPARAM_BUTTON_STATE = "state";

    @Override
    protected void script() {
        String buttonName = assertInput(IPARAM_BUTTON_NAME) as String;
        String buttonState = assertInput(IPARAM_BUTTON_STATE) as String;

        Node symbolButton = robot.lookup("#" + buttonName + "Symbol").queryFirst();

        evaluate(ExecutionDetails.create("Symbol button found ")
                .expected("Symbol button is not null")
                .success(symbolButton.isVisible()));

        switch(buttonState) {
            case "disabled":
                evaluate(ExecutionDetails.create("Verify that" + symbolButton + "call button state is: " + buttonState)
                        .expected("Button state is: " + buttonState)
                        .success(symbolButton.isDisabled()))
                break
            case "enabled":
                evaluate(ExecutionDetails.create("Verify that" + symbolButton + "call button state is: " + buttonState)
                        .expected("Button state is: " + buttonState)
                        .success(!symbolButton.isDisabled()))
                break
            default:
                break
        }
    }
}