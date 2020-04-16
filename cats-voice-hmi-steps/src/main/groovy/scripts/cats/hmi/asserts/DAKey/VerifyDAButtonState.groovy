package scripts.cats.hmi.asserts.DAKey

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate
import scripts.utils.VerifyPseudoClassStates

class VerifyDAButtonState extends FxScriptTemplate {
    public static final String IPARAM_DA_KEY_ID = "da_key_id";
    public static final String IPARAM_DA_KEY_STATE = "da_key_state";

    @Override
    void script() {
        String daKeyId = assertInput(IPARAM_DA_KEY_ID) as String;
        String daKeyState = assertInput(IPARAM_DA_KEY_STATE) as String;

        Node daWidget = robot.lookup("#" + daKeyId).queryFirst();

        final PseudoClass pseudoClassState = PseudoClass.getPseudoClass(daKeyState)

        evaluate(ExecutionDetails.create("Verify DA key was found")
                .expected("DA key with id " + daKeyId + " was found")
                .success(daWidget.isVisible()));

        evaluate(ExecutionDetails.create("Verify DA key has state: " + daKeyState)
                .success(VerifyPseudoClassStates.verifyNodeHasPseudoClass(daWidget, pseudoClassState, 3000)));
    }
}
