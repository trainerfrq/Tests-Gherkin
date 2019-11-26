package scripts.cats.hmi.asserts.DateAndTime

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.layout.HBox
import javafx.scene.text.Text
import scripts.agent.testfx.automation.FxScriptTemplate
import java.util.regex.Pattern

class VerifyTimeFormat extends FxScriptTemplate {
    public static final String IPARAM_ELEMENT_ID = "element_id"
    public static final String IPARAM_FORMAT = "format"

    @Override
    protected void script() {

        String widgetID = assertInput(IPARAM_ELEMENT_ID) as String
        String format = assertInput(IPARAM_FORMAT) as String

        HBox displayedTime = robot.lookup("#" + widgetID + " #timeLabelContainer").queryFirst()

        evaluate(ExecutionDetails.create("Displayed time was found")
                .expected("Time is visible")
                .success(displayedTime.isVisible()))

        checkTimeFormat(displayedTime.getChildren(), format)
    }

    private void checkTimeFormat(List<Node> displayedTime, String format) {
        String displayedTimeText = ""
        for (final Node node : displayedTime) {
            displayedTimeText += ((Text) node).getText()
        }

        if (Pattern.matches("HH.mm.ss", format)) {
            evaluate(ExecutionDetails.create("Time format is correct")
                    .received("Received time: " + displayedTimeText)
                    .expected("Expected format: " + format)
                    .success(Pattern.matches("[0-2][0-9].[0-5][0-9].[0-5][0-9]", displayedTimeText)))
        } else if (Pattern.matches("hh.mm.ss", format)) {
            evaluate(ExecutionDetails.create("Time format is correct")
                    .received("Received time: " + displayedTimeText)
                    .expected("Expected format: " + format)
                    .success(Pattern.matches("[0-1][0-9].[0-5][0-9].[0-5][0-9]", displayedTimeText)))
        }
    }
}
