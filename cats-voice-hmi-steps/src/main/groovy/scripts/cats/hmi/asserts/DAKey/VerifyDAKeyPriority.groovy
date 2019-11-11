package scripts.cats.hmi.asserts.DAKey

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyDAKeyPriority extends FxScriptTemplate {
    public static final String IPARAM_DA_KEY_ID = "da_key_id";
    public static final String IPARAM_DA_KEY_PRIORITY = "da_key_priority";

    @Override
    void script() {
        String daKeyId = assertInput(IPARAM_DA_KEY_ID) as String;
        String daKeyPriority = assertInput(IPARAM_DA_KEY_PRIORITY) as String;

        Node daWidget = robot.lookup("#" + daKeyId).queryFirst();

        evaluate(ExecutionDetails.create("Verify DA key was found")
                .expected("DA key with id " + daKeyId + " was found")
                .success(daWidget != null));

        if (daKeyPriority.toUpperCase().equals("EMERGENCY")) {
            evaluate(ExecutionDetails.create("Verify DA key has priority: " + daKeyPriority)
                    .expected("Expected priority: " + daKeyPriority)
                    .received("Received priority: " + daWidget.getStyleClass())
                    .success(daWidget.getStyleClass().contains("priority")));
        } else {
            evaluate(ExecutionDetails.create("Verify DA key has priority: " + daKeyPriority)
                    .expected("Expected priority: " + daKeyPriority)
                    .received("Received priority: " + daWidget.getStyleClass())
                    .success(!(daWidget.getStyleClass().contains("priority"))));
        }
    }
}
