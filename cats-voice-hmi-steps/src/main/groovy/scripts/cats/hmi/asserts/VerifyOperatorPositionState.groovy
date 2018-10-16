package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyOperatorPositionState extends FxScriptTemplate {

    public static final String ROOT_VIEW = "rootView"
    public static final String STATE = "state_mode"

    @Override
    void script() {

        String state = assertInput(STATE) as String

        Node rootView = robot.lookup("#" + ROOT_VIEW).queryFirst();

        evaluate(ExecutionDetails.create("Verify root view was found")
                .expected("Root view was found")
                .received(rootView.getStyleClass().toString())
                .success(rootView != null));

        evaluate(ExecutionDetails.create("Verify root view has styleClass: " + state)
                .success(verifyNodeHasClass(rootView, state, 10000)));
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
