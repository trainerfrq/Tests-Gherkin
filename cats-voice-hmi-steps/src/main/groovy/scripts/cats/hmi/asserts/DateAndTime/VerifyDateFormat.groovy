package scripts.cats.hmi.asserts.DateAndTime

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

import java.util.regex.Pattern

class VerifyDateFormat extends FxScriptTemplate {
    public static final String IPARAM_ELEMENT_ID = "element_id"
    public static final String IPARAM_FORMAT = "format"

    @Override
    protected void script() {

        String widgetID = assertInput(IPARAM_ELEMENT_ID) as String
        String format = assertInput(IPARAM_FORMAT) as String

        Label displayedDate = robot.lookup("#" + widgetID + " #dateLabel").queryFirst()

        evaluate(ExecutionDetails.create("Displayed date was found")
                .expected("Date is visible")
                .success(displayedDate.isVisible()))

        checkDateFormat(displayedDate.getText(), format)
    }

    private void checkDateFormat(String displayedDate, String format) {

        if (Pattern.matches("dd.MM.yyyy", format)) {
            evaluate(ExecutionDetails.create("Date format is correct")
                    .received("Received date: " + displayedDate)
                    .expected("Expected format: " + format)
                    .success(Pattern.matches("[0-3][0-9].[0-1][0-9].[0-9][0-9][0-9][0-9]", displayedDate)))
        } else if (Pattern.matches("MM.dd.yyyy", format)) {
            evaluate(ExecutionDetails.create("Date format is correct")
                    .received("Received date: " + displayedDate)
                    .expected("Expected format: " + format)
                    .success(Pattern.matches("[0-1][0-9].[0-3][0-9].[0-9][0-9][0-9][0-9]", displayedDate)))
        } else if (Pattern.matches("yyyy.MM.dd", format)) {
            evaluate(ExecutionDetails.create("Date format is correct")
                    .received("Received date: " + displayedDate)
                    .expected("Expected format: " + format)
                    .success(Pattern.matches("[0-9][0-9][0-9][0-9].[0-1][0-9].[0-3][0-9]", displayedDate)))
        } else {
            evaluate(ExecutionDetails.create("Date format is correct")
                    .received("Received date: " + displayedDate)
                    .expected("Expected format: " + format)
                    .success(Pattern.matches("[0-9][0-9][0-9][0-9].[0-3][0-9].[0-1][0-9]", displayedDate)))
        }
    }
}
