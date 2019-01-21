package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.agent.testfx.automation.FxScriptTemplate

import javafx.scene.control.Label

class VerifyFunctionKeyLabel extends FxScriptTemplate {

    public static final String IPARAM_KEY_ID = "key_id"
    public static final String IPARAM_LABEL = "label"

    @Override
    void script() {

        String KeyId = assertInput(IPARAM_KEY_ID) as String
        String expectedLabel = assertInput(IPARAM_LABEL) as String

        final Label GGLabel = robot.lookup( "#"+ KeyId + " #functionKeyLabel" ).queryFirst()

        evaluate(ExecutionDetails.create("Button displays the expected text ")
                .expected(expectedLabel)
                .received(GGLabel.getText())
                .success(GGLabel.getText() == expectedLabel))
    }
}
