package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCurrentRole extends FxScriptTemplate {

    public static final String IPARAM_STATUS_DISPLAY_TEXT = "status_display_text"

    @Override
    void script() {

        String text = assertInput (IPARAM_STATUS_DISPLAY_TEXT) as String

        Label statusDisplay = robot.lookup("#misisonPopup .assignedRoleName").queryFirst()

        evaluate(ExecutionDetails.create("Status display was found")
                .expected("statusDisplay is not null")
                .success(statusDisplay != null))

        if(statusDisplay != null){
            String textDisplay = statusDisplay.textProperty().getValue()
            evaluate(ExecutionDetails.create("Status displays the expected role")
                    .received("Received text is: " + textDisplay)
                    .expected("Expected text is: " + text)
                    .success(statusDisplay.textProperty().getValue().equals(text)))
        }
    }
}
