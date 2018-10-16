package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyKeyboardLabel extends FxScriptTemplate {

    public static final String IPARAM_KEY = "key"

    @Override
    void script() {

        String key = assertInput(IPARAM_KEY) as String

        Label label = robot.lookup( "#phonebookPopup #" + key + " .label" ).queryFirst();

        evaluate(ExecutionDetails.create("Key label displays the correct letter/symbol")
                .received("Received key is: " + label.getText())
                .expected("Expected text is: " + key)
                .success(label.getText().equals(key)));

    }
}
