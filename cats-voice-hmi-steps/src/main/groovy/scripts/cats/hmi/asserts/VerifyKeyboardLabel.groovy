package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyKeyboardLabel extends FxScriptTemplate {

    public static final String IPARAM_KEY_LABEL = "key_label"

    @Override
    void script() {

        String keyLabel = assertInput(IPARAM_KEY_LABEL) as String

        Label label = robot.lookup( "#phonebookPopup #" + keyLabel + " .label" ).queryFirst();

        evaluate(ExecutionDetails.create("Key label displays the correct letter/symbol")
                .received("Received key is: " + label.getText())
                .expected("Expected text is: " + keyLabel)
                .success(label.getText().equals(keyLabel)));

    }
}
