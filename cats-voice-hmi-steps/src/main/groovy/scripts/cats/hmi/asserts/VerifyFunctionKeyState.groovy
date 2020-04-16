package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.collections.ObservableSet
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate
import scripts.utils.VerifyPseudoClassStates

class VerifyFunctionKeyState extends FxScriptTemplate {

    public static final String IPARAM_KEY_ID = "key_id"
    public static final String IPARAM_KEY_STATE = "key_state"

    @Override
    void script() {

        String KeyId = assertInput(IPARAM_KEY_ID) as String
        String KeyState = assertInput(IPARAM_KEY_STATE) as String

        final PseudoClass pseudoClassState = PseudoClass.getPseudoClass(KeyState)

        Node widget = robot.lookup("#" + KeyId).queryFirst()
        evaluate(ExecutionDetails.create("Verify function key was found")
                .expected("Function key with id " + KeyId + " was found")
                .success(widget != null))

        evaluate(ExecutionDetails.create("Verify PseudoClassStates contains: " + KeyState)
                .success(VerifyPseudoClassStates.verifyNodeHasPseudoClass(widget, pseudoClassState, 3000)))
    }
}
