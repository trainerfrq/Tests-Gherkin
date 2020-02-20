package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.control.Label
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyDisplayedText extends FxScriptTemplate {

    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyDisplayedText.class);

    public static final String IPARAM_DISPLAY_PANEL_KEY = "display_panel_key";
    public static final String IPARAM_DISPLAYED_TEXT = "displayed_text";
    public static final String IPARAM_DISPLAY_LABEL = "display_label";

    @Override
    void script() {

        String key = assertInput(IPARAM_DISPLAY_PANEL_KEY) as String;
        String text = assertInput(IPARAM_DISPLAYED_TEXT) as String;
        String label = assertInput(IPARAM_DISPLAY_LABEL) as String;

        Label displayPanel = robot.lookup("#" + key + " #" + label).queryFirst();

        evaluate(ExecutionDetails.create(key + " was found")
                .expected(key + " is not null")
                .success(displayPanel != null));

        evaluate(ExecutionDetails.create("Verify " + key + " has property: " + text)
                .success(verifyNodeHasProperty(displayPanel, text, 3000)));

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
