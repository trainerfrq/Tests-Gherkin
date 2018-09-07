package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyStatusDisplay extends FxScriptTemplate {

    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyStatusDisplay.class);

    public static final String IPARAM_STATUS_DISPLAY_TEXT = "status_display_text";

    @Override
    void script() {

        String text = assertInput (IPARAM_STATUS_DISPLAY_TEXT) as String;

        Label statusDisplay = robot.lookup("#status1 #missionLabel").queryFirst();

        evaluate(ExecutionDetails.create("Status display was found")
                .expected("statusDisplay is not null")
                .success(statusDisplay != null));

        if(statusDisplay != null){
            String textDisplay = statusDisplay.textProperty().getValue()
            evaluate(ExecutionDetails.create("Status displays the expected mission")
                    .received("Expected text is: " + textDisplay)
                    .expected("Received text is: " + text)
                    .success(statusDisplay.textProperty().getValue().equals(text)));
        }
    }
}
