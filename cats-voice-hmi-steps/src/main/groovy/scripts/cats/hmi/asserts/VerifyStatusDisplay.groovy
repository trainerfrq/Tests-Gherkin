package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.control.Label
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyStatusDisplay extends FxScriptTemplate {

    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyStatusDisplay.class);

    public static final String IPARAM_STATUS_DISPLAY_KEY = "status_key";
    public static final String IPARAM_STATUS_DISPLAY_TEXT = "status_display_text";
    public static final String IPARAM_STATUS_DISPLAY_LABEL = "status_display_label";

    @Override
    void script() {

        String key = assertInput (IPARAM_STATUS_DISPLAY_KEY) as String;
        String text = assertInput (IPARAM_STATUS_DISPLAY_TEXT) as String;
        String label = assertInput (IPARAM_STATUS_DISPLAY_LABEL) as String;

        Label statusDisplay = robot.lookup("#"+key+" #"+label).queryFirst();

        evaluate(ExecutionDetails.create("Status display was found")
                .expected("statusDisplay is not null")
                .success(statusDisplay != null));

        if(statusDisplay != null){
            evaluate(ExecutionDetails.create("Verify status display has property: " + text)
                    .success(verifyNodeHasProperty(statusDisplay, text, 10000)));
        }
    }

    protected static boolean verifyNodeHasProperty(Label node, String property, long nWait) {

        WaitCondition condition = new WaitCondition("Wait until node has [" + property + "] value") {
            @Override
            boolean test() {
                String receivedProperty = node.textProperty().getValue();
                DSLSupport.evaluate(ExecutionDetails.create("Verifying has property")
                        .expected("Expected property: " + property)
                        .received("Found property: " + receivedProperty)
                        .success())
                return receivedProperty.contains(property);

            }
        }
        return WaitTimer.pause(condition, nWait, 400);
    }
}
