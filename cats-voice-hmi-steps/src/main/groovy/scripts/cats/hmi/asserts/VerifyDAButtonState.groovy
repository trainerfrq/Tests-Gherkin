package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyDAButtonState extends FxScriptTemplate {
    public static final String IPARAM_DA_KEY_ID = "da_key_id";
    public static final String IPARAM_DA_KEY_STATE = "da_key_state";

    @Override
    void script() {
        String daKeyId = assertInput(IPARAM_DA_KEY_ID) as String;
        String daKeyState = assertInput(IPARAM_DA_KEY_STATE) as String;

        Node daWidget = robot.lookup("#" + daKeyId).queryFirst();

        evaluate(ExecutionDetails.create("Verify DA key was found")
                .expected("DA key with id " + daKeyId + " was found")
                .success(daWidget != null));

        evaluate(ExecutionDetails.create("Verify DA key has styleClass: " + daKeyState)
                .success(verifyNodeHasClass(daWidget, daKeyState, 10000)));
    }

    protected static boolean verifyNodeHasClass(Node node, String className, long nWait) {
        String styleClass = node.styleClass.join(" ");
        WaitCondition condition = new WaitCondition("Wait until node has [" + className + "] class") {
            @Override
            boolean test() {
                DSLSupport.evaluate(ExecutionDetails.create("Verifying has class")
                        .expected("Expected class: " + className)
                        .received("Found classes: " + styleClass)
                        .success())
                return styleClass.contains(className);

            }
        }
        return WaitTimer.pause(condition, nWait, 400);
    }
}
