package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate
import scripts.utils.PseudoClassStates

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
                .success(PseudoClassStates.verifyNodeHasPseudoClass(widget, pseudoClassState, 3000)))
    }
}
