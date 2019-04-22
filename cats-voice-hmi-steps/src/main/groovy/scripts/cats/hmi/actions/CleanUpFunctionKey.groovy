package scripts.cats.hmi.actions

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
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
        String KeyState = assertInput(IPARAM_KEY_STATE) as String

        Node functionKeyWidget = robot.lookup("#" + functionKeyId).queryFirst();

        final PseudoClass pseudoClassState = PseudoClass.getPseudoClass(KeyState)

        Boolean state = verifyNodeHasPseudoClass(functionKeyWidget, pseudoClassState, 100)

        if (state){
            evaluate(ExecutionDetails.create("Button is in the expected state")
                    .success(true))
        }else{
            robot.clickOn(robot.point(functionKeyWidget));
            evaluate(ExecutionDetails.create("Button is in the expected state")
                    .success(true))
        }
    }

    protected static boolean verifyNodeHasPseudoClass(Node node, PseudoClass pseudoClassState, long nWait) {

        WaitCondition condition = new WaitCondition("Wait until node has [" + pseudoClassState + "] class") {
            @Override
            boolean test() {
                ObservableSet<PseudoClass> pseudoClass = node.pseudoClassStates
                DSLSupport.evaluate(ExecutionDetails.create("Verifying has class")
                        .expected("Expected class: " + pseudoClassState)
                        .received("Found classes: " + pseudoClass)
                        .success())
                return pseudoClass.contains(pseudoClassState)
            }
        }
        return WaitTimer.pause(condition, nWait, 400)
    }
}
