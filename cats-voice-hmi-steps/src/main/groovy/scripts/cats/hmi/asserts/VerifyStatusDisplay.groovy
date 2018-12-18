package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyStatusDisplay extends FxScriptTemplate {

    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyStatusDisplay.class);

    public static final String IPARAM_STATUS_DISPLAY_TEXT = "status_display_text";
    public static final String IPARAM_STATUS_DISPLAY_LABEL = "status_display_label";

    @Override
    void script() {

        String text = assertInput (IPARAM_STATUS_DISPLAY_TEXT) as String;
        String label = assertInput (IPARAM_STATUS_DISPLAY_LABEL) as String;

        Label statusDisplay = robot.lookup("#status1 #"+label).queryFirst();

        evaluate(ExecutionDetails.create("Status display was found")
                .expected("statusDisplay is not null")
                .success(statusDisplay != null));

        if(statusDisplay != null){
            String textDisplay = statusDisplay.textProperty().getValue()
            evaluate(ExecutionDetails.create("Status displays the expected text")
                    .received("Received text is: " + textDisplay)
                    .expected("Expected text is: " + text)
                    .success(statusDisplay.textProperty().getValue().equals(text)));
        }
    }
}
