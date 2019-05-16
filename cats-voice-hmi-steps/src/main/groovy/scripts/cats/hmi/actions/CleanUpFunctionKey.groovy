package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.collections.ObservableSet
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class CleanUpFunctionKey extends FxScriptTemplate {

    public static final String IPARAM_FUNCTION_KEY_ID = "function_key_id";
    public static final String IPARAM_KEY_STATE = "key_state"

    @Override
    void script() {

        String functionKeyId = assertInput(IPARAM_FUNCTION_KEY_ID) as String;
        String keyState = assertInput(IPARAM_KEY_STATE) as String

        Node functionKeyWidget = robot.lookup("#" + functionKeyId).queryFirst();

        final PseudoClass pseudoClassState = PseudoClass.getPseudoClass(keyState)

        ObservableSet<PseudoClass> pseudoClass = functionKeyWidget.getPseudoClassStates()

        if (pseudoClass.contains(pseudoClassState)){
            evaluate(ExecutionDetails.create("Button is in the expected state")
                    .received("Received state is: " + pseudoClass.toString())
                    .expected("Expected state is: "+keyState)
                    .success(true))
            robot.clickOn(robot.point(functionKeyWidget));
        }
        else{
            evaluate(ExecutionDetails.create("Button is in the expected state")
                    .received("Received state is not: "+pseudoClass.toString())
                    .expected("Expected state is not: "+keyState)
                    .success(true))
        }
    }
}
