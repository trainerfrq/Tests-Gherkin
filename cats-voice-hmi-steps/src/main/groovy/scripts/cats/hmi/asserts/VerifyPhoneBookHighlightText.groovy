package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import javafx.scene.text.Text
import javafx.scene.text.TextFlow
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyPhoneBookHighlightText extends FxScriptTemplate {

    public static final String IPARAM_HIGHLIGHT_TEXT = "highlight_text"

    @Override
    void script() {

        String highlightText = assertInput(IPARAM_HIGHLIGHT_TEXT) as String

        Set<TextFlow> cellTextFlowSet = robot.lookup( "#phonebookTable .tableCellTextFlow" ).queryAll();

        for ( Node node : cellTextFlowSet )
             {
                Text textNode = ( Text ) node;
                 evaluate(ExecutionDetails.create("Highlight text is the desired text")
                         .expected(highlightText)
                         .received(textNode.getText())
                         .success(textNode.getText() == highlightText))

                 evaluate(ExecutionDetails.create("Verify text is highlighted")
                         .success(verifyNodeHasClass(textNode, "searchHighlight", 1000)));

             }
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
