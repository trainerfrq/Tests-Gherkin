package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyStatusDisplay extends FxScriptTemplate {

    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyStatusDisplay.class);

    public static final String IPARAM_STATUS_DISPLAY_TEXT = "status_display_text";

    @Override
    void script() {

        String text = assertInput (IPARAM_STATUS_DISPLAY_TEXT) as String;

        Node statusDisplay = robot.lookup("status1").queryFirst();

        evaluate(ExecutionDetails.create("Status display was found")
                .expected("statusDisplay is not null")
                .success(statusDisplay != null));

        if(statusDisplay != null){
            String textDisplay = statusDisplay.text()
            evaluate(ExecutionDetails.create("Status displays the expected mission")
                    .received("Expected text is: " + textDisplay)
                    .expected("Received text is: " + text)
                    .success(textDisplay.contains(text)));
        }
    }
}
