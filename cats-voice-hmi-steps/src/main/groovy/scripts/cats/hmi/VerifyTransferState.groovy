package scripts.cats.hmi

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyTransferState extends FxScriptTemplate {

    public static final String ROOT_VIEW = "rootView"
    public static final String TRANSFER = "transfer"

    @Override
    void script() {

        Node rootView = robot.lookup("#" + ROOT_VIEW).queryFirst();

        evaluate(ExecutionDetails.create("Verify root view was found")
                .expected("Root view was found")
                .success(rootView != null));

        evaluate(ExecutionDetails.create("Verify root view has styleClass: " + TRANSFER)
                .success(verifyNodeHasClass(rootView, TRANSFER, 10000)));
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
