package scripts.cats.hmi.asserts.DateAndTime

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.regex.Pattern

class VerifySystemAndDisplayedDate extends FxScriptTemplate {
    public static final String IPARAM_ELEMENT_ID = "element_id"
    public static final String IPARAM_FORMAT = "format"

    @Override
    protected void script() {
        String widgetID = assertInput(IPARAM_ELEMENT_ID) as String
        String dateFormat = assertInput(IPARAM_FORMAT) as String

        Label displayedDate = robot.lookup("#" + widgetID + " #dateLabel").queryFirst()

        evaluate(ExecutionDetails.create("Displayed date was found")
                .expected("Date is visible")
                .success(displayedDate.isVisible()))

        testSystemAndHmiDate(displayedDate.getText(), dateFormat)
    }

    private void testSystemAndHmiDate(String displayedDate, String dateFormat) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(dateFormat)
        LocalDate systemDate = LocalDate.now()

        evaluate(ExecutionDetails.create("Check System and displayed date")
                .expected(systemDate.format(formatter).toString())
                .received(displayedDate)
                .success(displayedDate.equals(systemDate.format(formatter).toString())))

    }
}
