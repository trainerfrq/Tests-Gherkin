package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import javafx.scene.control.TableView
import javafx.scene.layout.Pane
import javafx.scene.text.Text
import javafx.scene.text.TextFlow
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyPhoneBookHighlightText extends FxScriptTemplate {

    public static final String IPARAM_HIGHLIGHT_TEXT = "highlight_text"

    @Override
    void script() {
        String highlightText = assertInput(IPARAM_HIGHLIGHT_TEXT) as String

        final TableView phonebookTable = robot.lookup( "#phonebookTable" ).queryFirst()
        phonebookTable.refresh()

        WaitTimer.pause(1000);

        Set<TextFlow> cellTextFlowSet = robot.lookup( "#phonebookTable .tableCellTextFlow" ).queryAll();
        Pane cellTextFlowTable = robot.lookup( "#phonebookTable .tableCellTextFlow" ).queryFirst()
        Node node = cellTextFlowTable.getChildren().first()
        Text textNode = ( Text ) node;

        for ( TextFlow cellTextFlow : cellTextFlowSet )
             {
                 evaluate(ExecutionDetails.create("Highlight text is the desired text")
                         .expected(highlightText)
                         .received(textNode.getText())
                         .success(textNode.getText().toLowerCase() == highlightText))

             }
    }
}
