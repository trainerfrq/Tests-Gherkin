package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.collections.ObservableSet
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyOperatorPositionState extends FxScriptTemplate {

    public static final String IPARAM_KEY_ID = "key_id"
    public static final String IPARAM_KEY_STATE = "key_state"

    @Override
    void script() {

        String daKeyId = assertInput(IPARAM_KEY_ID) as String
        String daKeyState = assertInput(IPARAM_KEY_STATE) as String

        final PseudoClass pseudoClassState = PseudoClass.getPseudoClass(daKeyState)

        Node daWidget = robot.lookup("#" + daKeyId).queryFirst()
        evaluate(ExecutionDetails.create("Verify key was found")
                .expected("Key with id " + daKeyId + " was found")
                .success(daWidget != null))

        evaluate(ExecutionDetails.create("Verify PseudoClassStates contains: " + daKeyState)
                .success(verifyNodeHasPseudoClass(daWidget, pseudoClassState, 10000)))
    }

    protected static boolean verifyNodeHasPseudoClass(Node node, PseudoClass pseudoClassState, long nWait) {

        ObservableSet<PseudoClass> pseudoClass = node.pseudoClassStates

        WaitCondition condition = new WaitCondition("Wait until node has [" + pseudoClassState + "] class") {
            @Override
            boolean test() {
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
